import '../entities/return_item.dart';
import '../../core/errors/failures.dart';

abstract class ReturnItemRepository {
  /// Get all return items for a specific user
  Future<Either<Failure, List<ReturnItem>>> getReturnItems(String userId);

  /// Get a specific return item by ID
  Future<Either<Failure, ReturnItem>> getReturnItem(String itemId);

  /// Create a new return item
  Future<Either<Failure, ReturnItem>> createReturnItem(ReturnItem item);

  /// Update an existing return item
  Future<Either<Failure, ReturnItem>> updateReturnItem(ReturnItem item);

  /// Delete a return item
  Future<Either<Failure, void>> deleteReturnItem(String itemId);

  /// Get return items by status
  Future<Either<Failure, List<ReturnItem>>> getReturnItemsByStatus(
    String userId,
    ReturnStatus status,
  );

  /// Get upcoming deadline items
  Future<Either<Failure, List<ReturnItem>>> getUpcomingDeadlineItems(
    String userId,
    int daysThreshold,
  );

  /// Search return items
  Future<Either<Failure, List<ReturnItem>>> searchReturnItems(
    String userId,
    String query,
  );

  /// Get return items statistics
  Future<Either<Failure, ReturnItemStats>> getReturnItemStats(String userId);

  /// Sync return items with remote server
  Future<Either<Failure, void>> syncReturnItems(String userId);
}

class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  const Either.left(L value)
      : _left = value,
        _right = null,
        _isLeft = true;

  const Either.right(R value)
      : _left = null,
        _right = value,
        _isLeft = false;

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  L? get left => _left;
  R? get right => _right;

  T fold<T>(T Function(L) leftFunction, T Function(R) rightFunction) {
    if (_isLeft) {
      return leftFunction(_left as L);
    } else {
      return rightFunction(_right as R);
    }
  }
}

class ReturnItemStats {
  final int totalItems;
  final int pendingItems;
  final int completedItems;
  final int expiredItems;
  final int urgentItems;
  final double totalValue;
  final double averageReturnWindow;

  const ReturnItemStats({
    required this.totalItems,
    required this.pendingItems,
    required this.completedItems,
    required this.expiredItems,
    required this.urgentItems,
    required this.totalValue,
    required this.averageReturnWindow,
  });

  @override
  String toString() {
    return 'ReturnItemStats(total: $totalItems, pending: $pendingItems, completed: $completedItems)';
  }
}
