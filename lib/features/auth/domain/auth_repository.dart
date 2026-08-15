abstract interface class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String?> getUserId();
}