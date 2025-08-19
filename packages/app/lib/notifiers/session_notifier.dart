import "package:core/core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";

class SessionNotifier extends ChangeNotifier {
  SessionNotifier() {
    _auth.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      GetIt.I<LogProvider>().log("Succeded login", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log("Failed to log with error: ${e.message}", Severity.error);
      throw Exception(e.message);
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      GetIt.I<LogProvider>().log("Succeded register", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log("Failed to register with error: ${e.message}", Severity.error);
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      GetIt.I<LogProvider>().log("Succeded logout", Severity.info);
    } on FirebaseAuthException catch (e) {
      GetIt.I<LogProvider>().log("Failed to logout with error: ${e.message}", Severity.error);
      throw Exception(e.message);
    }
  }
}
