import "package:cloud_firestore/cloud_firestore.dart";
import "package:core/core.dart";
import "package:firebase_auth/firebase_auth.dart";

import "firestore_manager.dart";

class SessionManager {
  SessionManager() {
    userStream.listen((firebaseUser) {
      _user = firebaseUser;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Stream<User?> get userStream => _auth.authStateChanges();
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (user == null) {
        throw Exception("User is null");
      }

      GetIt.I<FirestoreManager>()
          .getDocument(collectionPath: "users", documentId: user?.uid ?? "")
          .then((value) {
            if (value == null) {
              GetIt.I<LogProvider>().log(
                "User first login, creating user on firestore",
                Severity.info,
              );
              GetIt.I<FirestoreManager>().setDocument(
                collectionPath: "users",
                documentId: user!.uid,
                data: {
                  "uid": user!.uid,
                  "email": user!.email,
                  "displayName": user!.displayName,
                  "photoURL": user!.photoURL,
                  "lastUpdated": FieldValue.serverTimestamp(),
                },
              );
            }
          });

      GetIt.I<LogProvider>().log("Succeded login", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log(
        "Failed to log with error: ${e.message}",
        Severity.error,
      );
      throw Exception(e.message);
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      GetIt.I<LogProvider>().log("Succeded register", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log(
        "Failed to register with error: ${e.message}",
        Severity.error,
      );
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      GetIt.I<LogProvider>().log("Succeded logout", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log(
        "Failed to logout with error: ${e.message}",
        Severity.error,
      );
      throw Exception(e.message);
    }
  }
}
