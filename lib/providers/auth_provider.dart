import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderlust/core/services/firebase_auth_service.dart';

// Define the state as a user or null (for signed-out state)
class AuthState {
  final User? user;
  AuthState({this.user});
}

// AuthNotifier to manage sign-in, sign-up, and sign-out
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  // Sign in with email and password
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailPassword(email, password);
      if (user != null) {
        state = AuthState(user: user);
      }
    } catch (e) {
      throw Exception('Failed to sign in');
    }
  }

  // Register with email and password
  Future<void> registerWithEmailPassword(String email, String password) async {
    try {
      final user =
          await _authService.registerWithEmailPassword(email, password);
      if (user != null) {
        state = AuthState(user: user);
      }
    } catch (e) {
      throw Exception('Failed to register');
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        state = AuthState(user: user);
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState(user: null);
  }

  // Get the current user
  Future<void> getCurrentUser() async {
    final user = await _authService.getCurrentUser();
    state = AuthState(user: user);
  }
}

// Create the AuthProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = FirebaseAuthService();
  return AuthNotifier(authService);
});
