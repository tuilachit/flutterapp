import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../data/datasources/auth_datasource.dart';

// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth data source provider
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return SupabaseAuthDataSource();
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthService(dataSource);
});

class AuthService {
  final AuthDataSource _dataSource;

  AuthService(this._dataSource);

  Future<Either<Failure, User>> signInWithEmail(String email, String password) {
    return _dataSource.signInWithEmail(email, password);
  }

  Future<Either<Failure, User>> signUpWithEmail(String email, String password, {String? fullName}) {
    return _dataSource.signUpWithEmail(email, password, fullName: fullName);
  }

  Future<Either<Failure, void>> signOut() {
    return _dataSource.signOut();
  }

  Future<Either<Failure, User>> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  bool get isAuthenticated => SupabaseConfig.isAuthenticated;
  
  String? get currentUserId => SupabaseConfig.currentUserId;
}

// Import the Either class and Failure
import '../../core/errors/failures.dart';
import '../../domain/repositories/return_item_repository.dart';