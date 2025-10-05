import { Router } from "express";
import admin from "firebase-admin";
import authMiddleware from "../middleware/auth";

const router = Router();

/// Helper: normalize GeoPoint -> { latitude, longitude }
function normalizeCoordinates(coords: any) {
    if (!coords) return null;
    if (coords instanceof admin.firestore.GeoPoint) {
        return { latitude: coords.latitude, longitude: coords.longitude };
    }
    if (typeof coords.latitude === "number" && typeof coords.longitude === "number") {
        return { latitude: coords.latitude, longitude: coords.longitude };
    }
    return null;
}

/// GET /trips
router.get("/", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;

        const tripsRef = admin.firestore().collection("users").doc(uid).collection("trips");
        const snapshot = await tripsRef.get();

        const trips = snapshot.docs.map(doc => {
            const data = doc.data();

            return {
                id: doc.id,
                ...data,
                start_date: data.start_date?.toDate().toISOString(),
                end_date: data.end_date?.toDate().toISOString(),
            };
        });

        res.json(trips);
    } catch (err) {
        console.error("Error fetching trips:", err);
        res.status(500).json({ error: "Failed to fetch trips" });
    }
});

/// GET /trips/:tripId/interest_points
router.get("/:tripId/interest_points", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;
        const { tripId } = req.params;

        if (!tripId) {
            return res.status(400).json({ error: "Missing tripId parameter" });
        }

        const interestPointsRef = admin
            .firestore()
            .collection("users")
            .doc(uid)
            .collection("trips")
            .doc(tripId)
            .collection("interest_points");

        const snapshot = await interestPointsRef.get();

        const interestPoints = snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                id: doc.id,
                ...data,
                date: data.date?.toDate().toISOString(),
                coordinates: normalizeCoordinates(data.coordinates),
            };
        });

        return res.json(interestPoints);
    } catch (err) {
        console.error("Error fetching interest points:", err);
        return res.status(500).json({ error: "Failed to fetch interest points" });
    }
});

/// POST /trips/:tripId/interest_points
router.post("/:tripId/interest_points", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;
        const { tripId } = req.params;

        if (!tripId) {
            return res.status(400).json({ error: "Missing tripId parameter" });
        }

        const { title, description, coordinates, date, visited } = req.body;

        if (!title || !description || !coordinates || !date) {
            return res.status(400).json({
                error: "Missing required fields: title, description, coordinates, date",
            });
        }

        if (
            typeof coordinates.latitude !== "number" ||
            typeof coordinates.longitude !== "number"
        ) {
            return res.status(400).json({
                error: "Invalid coordinates format. Expected { latitude: number, longitude: number }",
            });
        }

        const jsDate = new Date(date);
        if (isNaN(jsDate.getTime())) {
            return res.status(400).json({ error: "Invalid date format, expected ISO 8601 string" });
        }

        const parsedDate = admin.firestore.Timestamp.fromDate(jsDate);

        const interestPointsRef = admin
            .firestore()
            .collection("users")
            .doc(uid)
            .collection("trips")
            .doc(tripId)
            .collection("interest_points");

        const newPointRef = interestPointsRef.doc();

        const newPoint = {
            title,
            description,
            coordinates: new admin.firestore.GeoPoint(
                coordinates.latitude,
                coordinates.longitude
            ),
            date: parsedDate,
            visited,
            created_at: admin.firestore.FieldValue.serverTimestamp(),
        };

        await newPointRef.set(newPoint);

        return res.status(201).json({
            id: newPointRef.id,
            title,
            description,
            coordinates: normalizeCoordinates(newPoint.coordinates),
            date: jsDate.toISOString(),
            visited
        });
    } catch (err) {
        console.error("Error adding interest point:", err);
        return res.status(500).json({ error: "Failed to add interest point" });
    }
});

/// PATCH /trips/:tripId/interest_points/visited
router.patch("/:tripId/interest_points/visited", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;
        const { tripId } = req.params;

        if (!tripId) {
            return res.status(400).json({ error: "Missing tripId parameter" });
        }

        const updates = req.body;

        if (!Array.isArray(updates) || updates.length === 0) {
            return res.status(400).json({
                error: "Request body must be a non-empty array of interest points",
            });
        }

        const batch = admin.firestore().batch();
        const updatedPointIds: string[] = [];

        for (const update of updates) {
            const { pointId, visited } = update;

            if (!pointId || typeof visited !== "boolean") {
                return res.status(400).json({ error: "Wrong input data" });
            }

            const pointRef = admin
                .firestore()
                .collection("users")
                .doc(uid)
                .collection("trips")
                .doc(tripId)
                .collection("interest_points")
                .doc(pointId);

            const doc = await pointRef.get();
            if (!doc.exists) {
                return res.status(400).json({ error: "Document not found" });
            }

            batch.update(pointRef, {
                visited,
                updated_at: admin.firestore.FieldValue.serverTimestamp(),
            });

            updatedPointIds.push(pointId);
        }

        if (updatedPointIds.length > 0) {
            await batch.commit();
        } else {
            return res.status(400).json({ error: "No valid interest points to update" });
        }

        return res.status(200).json({
            message: "Visited status updated successfully",
            updated: updatedPointIds,
        });
    } catch (err) {
        console.error("Error updating visited status:", err, req.body);
        return res.status(500).json({ error: "Failed to update visited status" });
    }
});

/// PATCH /trips/:tripId/interest_points/:pointId
router.patch("/:tripId/interest_points/:pointId", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;
        const { tripId, pointId } = req.params;

        if (!tripId || !pointId) {
            return res.status(400).json({ error: "Missing tripId or pointId parameter" });
        }

        const { title, description, coordinates, date } = req.body;

        const updates: any = {};

        if (title !== undefined) updates.title = title;
        if (description !== undefined) updates.description = description;

        if (coordinates !== undefined) {
            if (
                typeof coordinates.latitude !== "number" ||
                typeof coordinates.longitude !== "number"
            ) {
                return res.status(400).json({
                    error: "Invalid coordinates format. Expected { latitude: number, longitude: number }",
                });
            }
            updates.coordinates = new admin.firestore.GeoPoint(
                coordinates.latitude,
                coordinates.longitude
            );
        }

        if (date !== undefined) {
            const jsDate = new Date(date);
            if (isNaN(jsDate.getTime())) {
                return res.status(400).json({ error: "Invalid date format, expected ISO 8601 string" });
            }
            updates.date = admin.firestore.Timestamp.fromDate(jsDate);
        }

        if (Object.keys(updates).length === 0) {
            return res.status(400).json({ error: "No valid fields provided to update" });
        }

        updates.updated_at = admin.firestore.FieldValue.serverTimestamp();

        const pointRef = admin
            .firestore()
            .collection("users")
            .doc(uid)
            .collection("trips")
            .doc(tripId)
            .collection("interest_points")
            .doc(pointId);

        await pointRef.update(updates);

        const updatedDoc = await pointRef.get();
        const updatedData = updatedDoc.data();

        return res.status(200).json({
            id: pointId,
            ...updatedData,
            date: updatedData?.date?.toDate().toISOString(),
            coordinates: normalizeCoordinates(updatedData?.coordinates),
        });
    } catch (err) {
        console.error("Error updating interest point:", err);
        return res.status(500).json({ error: "Failed to update interest point" });
    }
});

/// DELETE /trips/:tripId/interest_points/:pointId
router.delete("/:tripId/interest_points/:pointId", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;
        const { tripId, pointId } = req.params;

        if (!tripId || !pointId) {
            return res.status(400).json({ error: "Missing tripId or pointId parameter" });
        }

        const pointRef = admin
            .firestore()
            .collection("users")
            .doc(uid)
            .collection("trips")
            .doc(tripId)
            .collection("interest_points")
            .doc(pointId);

        const doc = await pointRef.get();
        if (!doc.exists) {
            return res.status(404).json({ error: "Interest point not found" });
        }

        await pointRef.delete();

        return res.status(200).json({ message: "Interest point deleted successfully", id: pointId });
    } catch (err) {
        console.error("Error deleting interest point:", err);
        return res.status(500).json({ error: "Failed to delete interest point" });
    }
});

export default router;
