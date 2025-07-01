import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/datasources/return_item_datasource.dart';
import '../../data/repositories/return_item_repository_impl.dart';
import '../../domain/entities/return_item.dart';
import '../../domain/repositories/return_item_repository.dart';
import '../../domain/usecases/get_return_items.dart';
import 'auth_provider.dart';

// Data source provider
final returnItemDataSourceProvider = Provider<ReturnItemDataSource>((ref) {
  return SupabaseReturnItemDataSource();
});

// Repository provider
final returnItemRepositoryProvider = Provider<ReturnItemRepository>((ref) {
  final dataSource = ref.read(returnItemDataSourceProvider);
  return ReturnItemRepositoryImpl(dataSource);
});

// Use cases providers
final getReturnItemsUseCaseProvider = Provider<GetReturnItems>((ref) {
  final repository = ref.read(returnItemRepositoryProvider);
  return GetReturnItems(repository);
});

final getReturnItemsByStatusUseCaseProvider = Provider<GetReturnItemsByStatus>((ref) {
  final repository = ref.read(returnItemRepositoryProvider);
  return GetReturnItemsByStatus(repository);
});

final getUpcomingDeadlineItemsUseCaseProvider = Provider<GetUpcomingDeadlineItems>((ref) {
  final repository = ref.read(returnItemRepositoryProvider);
  return GetUpcomingDeadlineItems(repository);
});

// Return items state provider
final returnItemsProvider = FutureProvider<List<ReturnItem>>((ref) async {
  final authService = ref.read(authServiceProvider);
  final useCase = ref.read(getReturnItemsUseCaseProvider);
  
  final userId = authService.currentUserId;
  if (userId == null) {
    throw const AuthenticationFailure(message: 'User not authenticated');
  }

  final result = await useCase(userId);
  return result.fold(
    (failure) => throw failure,
    (items) => items,
  );
});

// Return items by status provider
final returnItemsByStatusProvider = FutureProvider.family<List<ReturnItem>, ReturnStatus>((ref, status) async {
  final authService = ref.read(authServiceProvider);
  final useCase = ref.read(getReturnItemsByStatusUseCaseProvider);
  
  final userId = authService.currentUserId;
  if (userId == null) {
    throw const AuthenticationFailure(message: 'User not authenticated');
  }

  final result = await useCase(userId, status);
  return result.fold(
    (failure) => throw failure,
    (items) => items,
  );
});

// Upcoming deadline items provider
final upcomingDeadlineItemsProvider = FutureProvider.family<List<ReturnItem>, int>((ref, daysThreshold) async {
  final authService = ref.read(authServiceProvider);
  final useCase = ref.read(getUpcomingDeadlineItemsUseCaseProvider);
  
  final userId = authService.currentUserId;
  if (userId == null) {
    throw const AuthenticationFailure(message: 'User not authenticated');
  }

  final result = await useCase(userId, daysThreshold: daysThreshold);
  return result.fold(
    (failure) => throw failure,
    (items) => items,
  );
});

// Return item stats provider
final returnItemStatsProvider = FutureProvider<ReturnItemStats>((ref) async {
  final authService = ref.read(authServiceProvider);
  final repository = ref.read(returnItemRepositoryProvider);
  
  final userId = authService.currentUserId;
  if (userId == null) {
    throw const AuthenticationFailure(message: 'User not authenticated');
  }

  final result = await repository.getReturnItemStats(userId);
  return result.fold(
    (failure) => throw failure,
    (stats) => stats,
  );
});

// Return item service provider for mutations
final returnItemServiceProvider = Provider<ReturnItemService>((ref) {
  final repository = ref.read(returnItemRepositoryProvider);
  return ReturnItemService(repository, ref);
});

class ReturnItemService {
  final ReturnItemRepository _repository;
  final Ref _ref;

  ReturnItemService(this._repository, this._ref);

  Future<Either<Failure, ReturnItem>> createReturnItem(ReturnItem item) async {
    final result = await _repository.createReturnItem(item);
    
    // Refresh the providers after successful creation
    result.fold(
      (failure) => null,
      (item) {
        _ref.invalidate(returnItemsProvider);
        _ref.invalidate(returnItemStatsProvider);
      },
    );
    
    return result;
  }

  Future<Either<Failure, ReturnItem>> updateReturnItem(ReturnItem item) async {
    final result = await _repository.updateReturnItem(item);
    
    // Refresh the providers after successful update
    result.fold(
      (failure) => null,
      (item) {
        _ref.invalidate(returnItemsProvider);
        _ref.invalidate(returnItemStatsProvider);
      },
    );
    
    return result;
  }

  Future<Either<Failure, void>> deleteReturnItem(String itemId) async {
    final result = await _repository.deleteReturnItem(itemId);
    
    // Refresh the providers after successful deletion
    result.fold(
      (failure) => null,
      (_) {
        _ref.invalidate(returnItemsProvider);
        _ref.invalidate(returnItemStatsProvider);
      },
    );
    
    return result;
  }
}