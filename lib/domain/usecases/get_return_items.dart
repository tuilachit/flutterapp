import '../entities/return_item.dart';
import '../repositories/return_item_repository.dart';
import '../../core/errors/failures.dart';

class GetReturnItems {
  final ReturnItemRepository repository;

  const GetReturnItems(this.repository);

  Future<Either<Failure, List<ReturnItem>>> call(String userId) async {
    return await repository.getReturnItems(userId);
  }
}

class GetReturnItemsByStatus {
  final ReturnItemRepository repository;

  const GetReturnItemsByStatus(this.repository);

  Future<Either<Failure, List<ReturnItem>>> call(
    String userId,
    ReturnStatus status,
  ) async {
    return await repository.getReturnItemsByStatus(userId, status);
  }
}

class GetUpcomingDeadlineItems {
  final ReturnItemRepository repository;

  const GetUpcomingDeadlineItems(this.repository);

  Future<Either<Failure, List<ReturnItem>>> call(
    String userId, {
    int daysThreshold = 7,
  }) async {
    return await repository.getUpcomingDeadlineItems(userId, daysThreshold);
  }
}
