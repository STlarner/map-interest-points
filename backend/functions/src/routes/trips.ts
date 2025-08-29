import { Router } from "express";
import admin from "firebase-admin";
import authMiddleware from "../middleware/auth";

const router = Router();

router.get("/", authMiddleware, async (req, res) => {
    try {
        const user = (req as any).user;
        const uid = user.uid;

        const tripsRef = admin.firestore().collection("users").doc(uid).collection("trips");
        const snapshot = await tripsRef.get();

        const trips = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

        res.json(trips);
    } catch (err) {
        console.error("Error fetching trips:", err);
        res.status(500).json({ error: "Failed to fetch trips" });
    }
});

export default router;
