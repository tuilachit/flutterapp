import '../../core/errors/failures.dart';
import '../../domain/entities/return_item.dart';
import '../../domain/repositories/return_item_repository.dart';
import '../datasources/return_item_datasource.dart';

class ReturnItemRepositoryImpl implements ReturnItemRepository {
  final ReturnItemDataSource dataSource;

  const ReturnItemRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ReturnItem>>> getReturnItems(String userId) {
    return dataSource.getReturnItems(userId);
  }

  @override
  Future<Either<Failure, ReturnItem>> getReturnItem(String itemId) {
    return dataSource.getReturnItem(itemId);
  }

  @override
  Future<Either<Failure, ReturnItem>> createReturnItem(ReturnItem item) {
    return dataSource.createReturnItem(item);
  }

  @override
  Future<Either<Failure, ReturnItem>> updateReturnItem(ReturnItem item) {
    return dataSource.updateReturnItem(item);
  }

  @override
  Future<Either<Failure, void>> deleteReturnItem(String itemId) {
    return dataSource.deleteReturnItem(itemId);
  }

  @override
  Future<Either<Failure, List<ReturnItem>>> getReturnItemsByStatus(String userId, ReturnStatus status) {
    return dataSource.getReturnItemsByStatus(userId, status);
  }

  @override
  Future<Either<Failure, List<ReturnItem>>> getUpcomingDeadlineItems(String userId, int daysThreshold) {
    return dataSource.getUpcomingDeadlineItems(userId, daysThreshold);
  }

  @override
  Future<Either<Failure, List<ReturnItem>>> searchReturnItems(String userId, String query) async {
    // Get all items first, then filter locally
    final result = await dataSource.getReturnItems(userId);
    
    return result.fold(
      (failure) => Either.left(failure),
      (items) {
        final filteredItems = items.where((item) {
          final searchQuery = query.toLowerCase();
          return item.itemName.toLowerCase().contains(searchQuery) ||
                 item.brand.toLowerCase().contains(searchQuery) ||
                 item.store.toLowerCase().contains(searchQuery) ||
                 item.category.toLowerCase().contains(searchQuery);
        }).toList();
        
        return Either.right(filteredItems);
      },
    );
  }

  @override
  Future<Either<Failure, ReturnItemStats>> getReturnItemStats(String userId) {
    return dataSource.getReturnItemStats(userId);
  }

  @override
  Future<Either<Failure, void>> syncReturnItems(String userId) async {
    // For now, just return success as we're always synced with Supabase
    // In the future, this could handle offline sync logic
    return const Either.right(null);
  }
}