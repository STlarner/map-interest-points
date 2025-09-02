import { Router } from "express";
import admin from "firebase-admin";
import authMiddleware from "../middleware/auth";

const router = Router();


/// GET /trips
/// Get all trips of the user
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
/// Get all interest points of a trip
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
                latitude: data.latitude,
                longitude: data.longitude,
            };
        });

        return res.json(interestPoints);
    } catch (err) {
        console.error("Error fetching interest points:", err);
        return res.status(500).json({ error: "Failed to fetch interest points" });
    }
});


export default router;
