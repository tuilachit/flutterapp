import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/return_item.dart';
import '../../domain/repositories/return_item_repository.dart';

abstract class ReturnItemDataSource {
  Future<Either<Failure, List<ReturnItem>>> getReturnItems(String userId);
  Future<Either<Failure, ReturnItem>> getReturnItem(String itemId);
  Future<Either<Failure, ReturnItem>> createReturnItem(ReturnItem item);
  Future<Either<Failure, ReturnItem>> updateReturnItem(ReturnItem item);
  Future<Either<Failure, void>> deleteReturnItem(String itemId);
  Future<Either<Failure, List<ReturnItem>>> getReturnItemsByStatus(String userId, ReturnStatus status);
  Future<Either<Failure, List<ReturnItem>>> getUpcomingDeadlineItems(String userId, int daysThreshold);
  Future<Either<Failure, ReturnItemStats>> getReturnItemStats(String userId);
}

class SupabaseReturnItemDataSource implements ReturnItemDataSource {
  final SupabaseClient _client = SupabaseConfig.client;

  @override
  Future<Either<Failure, List<ReturnItem>>> getReturnItems(String userId) async {
    try {
      final response = await _client
          .from('return_items')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final items = (response as List)
          .map((json) => ReturnItem.fromJson(json))
          .toList();

      return Either.right(items);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error fetching return items: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, ReturnItem>> getReturnItem(String itemId) async {
    try {
      final response = await _client
          .from('return_items')
          .select()
          .eq('id', itemId)
          .single();

      final item = ReturnItem.fromJson(response);
      return Either.right(item);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error fetching return item: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, ReturnItem>> createReturnItem(ReturnItem item) async {
    try {
      final data = item.toJson();
      data['user_id'] = SupabaseConfig.currentUserId;
      
      final response = await _client
          .from('return_items')
          .insert(data)
          .select()
          .single();

      final createdItem = ReturnItem.fromJson(response);
      return Either.right(createdItem);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error creating return item: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, ReturnItem>> updateReturnItem(ReturnItem item) async {
    try {
      final data = item.toJson();
      data['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _client
          .from('return_items')
          .update(data)
          .eq('id', item.id)
          .select()
          .single();

      final updatedItem = ReturnItem.fromJson(response);
      return Either.right(updatedItem);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error updating return item: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReturnItem(String itemId) async {
    try {
      await _client
          .from('return_items')
          .delete()
          .eq('id', itemId);

      return const Either.right(null);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error deleting return item: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ReturnItem>>> getReturnItemsByStatus(String userId, ReturnStatus status) async {
    try {
      final response = await _client
          .from('return_items')
          .select()
          .eq('user_id', userId)
          .eq('status', status.value)
          .order('return_deadline', ascending: true);

      final items = (response as List)
          .map((json) => ReturnItem.fromJson(json))
          .toList();

      return Either.right(items);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error fetching return items by status: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ReturnItem>>> getUpcomingDeadlineItems(String userId, int daysThreshold) async {
    try {
      final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
      
      final response = await _client
          .from('return_items')
          .select()
          .eq('user_id', userId)
          .eq('status', 'pending')
          .lte('return_deadline', thresholdDate.toIso8601String())
          .order('return_deadline', ascending: true);

      final items = (response as List)
          .map((json) => ReturnItem.fromJson(json))
          .toList();

      return Either.right(items);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error fetching upcoming deadline items: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, ReturnItemStats>> getReturnItemStats(String userId) async {
    try {
      // Get all items for the user
      final allItemsResponse = await _client
          .from('return_items')
          .select()
          .eq('user_id', userId);

      final allItems = (allItemsResponse as List)
          .map((json) => ReturnItem.fromJson(json))
          .toList();

      // Calculate statistics
      final totalItems = allItems.length;
      final pendingItems = allItems.where((item) => item.status == ReturnStatus.pending).length;
      final completedItems = allItems.where((item) => item.status == ReturnStatus.completed).length;
      final expiredItems = allItems.where((item) => item.status == ReturnStatus.expired).length;
      final urgentItems = allItems.where((item) => item.isUrgent && item.status == ReturnStatus.pending).length;
      final totalValue = allItems.fold<double>(0, (sum, item) => sum + item.price);
      
      // Calculate average return window
      double averageReturnWindow = 0;
      if (allItems.isNotEmpty) {
        final totalDays = allItems.fold<int>(0, (sum, item) {
          return sum + item.returnDeadline.difference(item.purchaseDate).inDays;
        });
        averageReturnWindow = totalDays / allItems.length;
      }

      final stats = ReturnItemStats(
        totalItems: totalItems,
        pendingItems: pendingItems,
        completedItems: completedItems,
        expiredItems: expiredItems,
        urgentItems: urgentItems,
        totalValue: totalValue,
        averageReturnWindow: averageReturnWindow,
      );

      return Either.right(stats);
    } on PostgrestException catch (e) {
      return Either.left(DatabaseFailure(
        message: e.message,
        code: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      return Either.left(NetworkFailure(
        message: 'Error calculating return item stats: $e',
      ));
    }
  }
}