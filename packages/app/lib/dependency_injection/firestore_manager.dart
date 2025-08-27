import "package:cloud_firestore/cloud_firestore.dart";
import "package:core/core.dart";
import "package:firebase_storage/firebase_storage.dart";

class FirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Create or update a document
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true, // merge with existing data
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));
      GetIt.I<LogProvider>().log(
        "Document $documentId set successfully in $collectionPath",
        Severity.info,
      );
    } catch (e) {
      GetIt.I<LogProvider>().log("Error setting document: $e", Severity.error);
    }
  }

  /// Read a single document
  Future<DocumentSnapshot?> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .get();
      if (doc.exists) {
        return doc;
      } else {
        GetIt.I<LogProvider>().log(
          "Document $documentId does not exist in $collectionPath",
          Severity.info,
        );
        return null;
      }
    } catch (e) {
      GetIt.I<LogProvider>().log("Error reading document: $e", Severity.error);
      return null;
    }
  }

  /// Read all documents from a collection
  Future<List<QueryDocumentSnapshot>> getCollection({
    required String collectionPath,
  }) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      return snapshot.docs;
    } catch (e) {
      GetIt.I<LogProvider>().log(
        "Error reading collection: $e",
        Severity.error,
      );
      return [];
    }
  }

  /// Update specific fields in a document
  Future<void> updateDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
      GetIt.I<LogProvider>().log(
        "Document $documentId updated successfully in $collectionPath",
        Severity.info,
      );
    } catch (e) {
      GetIt.I<LogProvider>().log("Error updating document: $e", Severity.error);
    }
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
      GetIt.I<LogProvider>().log(
        "Document $documentId deleted successfully from $collectionPath",
        Severity.info,
      );
    } catch (e) {
      GetIt.I<LogProvider>().log("Error deleting document: $e", Severity.error);
    }
  }

  /// Listen to a collection in real-time
  Stream<QuerySnapshot> listenToCollection({required String collectionPath}) {
    return _firestore.collection(collectionPath).snapshots();
  }

  /// Listen to a single document in real-time
  Stream<DocumentSnapshot> listenToDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _firestore.collection(collectionPath).doc(documentId).snapshots();
  }

  /// get download url for a file on storage
  Future<String> getDownloadUrl({required String filePath}) async {
    try {
      final url = await _storage.ref(filePath).getDownloadURL();
      return url;
    } catch (e) {
      GetIt.I<LogProvider>().log(
        "Error getting download url from $filePath: $e",
        Severity.error,
      );
      return "";
    }
  }

  /// get download url for a file on storage
  Reference? getStorageReference({required String filePath}) {
    try {
      final url = _storage.ref(filePath);
      return url;
    } catch (e) {
      GetIt.I<LogProvider>().log(
        "Error getting reference from $filePath: $e",
        Severity.error,
      );
      return null;
    }
  }
}
