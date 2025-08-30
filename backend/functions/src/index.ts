/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from "firebase-functions";
import express from "express";
import admin from "firebase-admin";

import tripRoutes from "./routes/trips";

if (admin.apps.length === 0) {
    admin.initializeApp();
}

const app = express();
app.use(express.json());

// Mount routes
app.use("/trips", tripRoutes);

// Export as one Cloud Function
export const api = functions.https.onRequest(app);
