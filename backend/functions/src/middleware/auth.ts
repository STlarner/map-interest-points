import { Request, Response, NextFunction } from "express";
import admin from "firebase-admin";

const authMiddleware = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const authHeader = req.headers.authorization;

    if (admin.apps.length === 0) {
        admin.initializeApp();
    }

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing token" });
        return;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        (req as any).user = decodedToken;
        next();
        return;
    } catch (err) {
        console.error("Auth error:", err);
        res.status(401).json({ error: err });
        return;
    }
};

export default authMiddleware;