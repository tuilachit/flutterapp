import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/return_item_repository.dart';

abstract class AuthDataSource {
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, User>> signUpWithEmail(String email, String password, {String? fullName});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> getCurrentUser();
  Stream<AuthState> get authStateChanges;
}

class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client = SupabaseConfig.client;

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return Either.right(response.user!);
      } else {
        return const Either.left(AuthenticationFailure(
          message: 'Sign in failed: No user returned',
        ));
      }
    } on AuthException catch (e) {
      return Either.left(AuthenticationFailure(
        message: e.message,
        code: e.statusCode?.toInt(),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Network error during sign in: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(String email, String password, {String? fullName}) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user != null) {
        return Either.right(response.user!);
      } else {
        return const Either.left(AuthenticationFailure(
          message: 'Sign up failed: No user returned',
        ));
      }
    } on AuthException catch (e) {
      return Either.left(AuthenticationFailure(
        message: e.message,
        code: e.statusCode?.toInt(),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Network error during sign up: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Either.right(null);
    } on AuthException catch (e) {
      return Either.left(AuthenticationFailure(
        message: e.message,
        code: e.statusCode?.toInt(),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Network error during sign out: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user != null) {
        return Either.right(user);
      } else {
        return const Either.left(AuthenticationFailure(
          message: 'No authenticated user found',
        ));
      }
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error getting current user: $e',
      ));
    }
  }

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}