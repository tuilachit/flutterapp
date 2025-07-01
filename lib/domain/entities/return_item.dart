enum ReturnStatus {
  pending,
  inProgress,
  completed,
  expired,
}

extension ReturnStatusExtension on ReturnStatus {
  String get value {
    switch (this) {
      case ReturnStatus.pending:
        return 'pending';
      case ReturnStatus.inProgress:
        return 'inProgress';
      case ReturnStatus.completed:
        return 'completed';
      case ReturnStatus.expired:
        return 'expired';
    }
  }

  static ReturnStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return ReturnStatus.pending;
      case 'inProgress':
        return ReturnStatus.inProgress;
      case 'completed':
        return ReturnStatus.completed;
      case 'expired':
        return ReturnStatus.expired;
      default:
        return ReturnStatus.pending;
    }
  }
}

class ReturnItem {
  final String id;
  final String itemName;
  final String brand;
  final String store;
  final double price;
  final DateTime purchaseDate;
  final DateTime returnDeadline;
  final String size;
  final String color;
  final String category; // e.g., "Hoodie", "Jeans", "Jacket"
  final String? receiptNumber;
  final String? orderNumber;
  final List<String> photos; // Photo file paths
  final String condition;
  final String? reasonForReturn;
  final bool isOnlinePurchase;
  final String? storeLocation;
  final ReturnStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? returnedAt;

  const ReturnItem({
    required this.id,
    required this.itemName,
    required this.brand,
    required this.store,
    required this.price,
    required this.purchaseDate,
    required this.returnDeadline,
    required this.size,
    required this.color,
    required this.category,
    this.receiptNumber,
    this.orderNumber,
    this.photos = const [],
    required this.condition,
    this.reasonForReturn,
    required this.isOnlinePurchase,
    this.storeLocation,
    required this.status,
    this.notes,
    required this.createdAt,
    this.returnedAt,
  });

  // JSON serialization for Supabase
  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      id: json['id'] as String,
      itemName: json['item_name'] as String,
      brand: json['brand'] as String,
      store: json['store'] as String,
      price: (json['price'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      returnDeadline: DateTime.parse(json['return_deadline'] as String),
      size: json['size'] as String,
      color: json['color'] as String,
      category: json['category'] as String,
      receiptNumber: json['receipt_number'] as String?,
      orderNumber: json['order_number'] as String?,
      photos: (json['item_photos'] as List<dynamic>?)?.cast<String>() ?? [],
      condition: json['condition'] as String,
      reasonForReturn: json['reason_for_return'] as String?,
      isOnlinePurchase: json['is_online_purchase'] as bool,
      storeLocation: json['store_location'] as String?,
      status: ReturnStatusExtension.fromString(json['status'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      returnedAt: json['returned_at'] != null
          ? DateTime.parse(json['returned_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'brand': brand,
      'store': store,
      'price': price,
      'purchase_date': purchaseDate.toIso8601String(),
      'return_deadline': returnDeadline.toIso8601String(),
      'size': size,
      'color': color,
      'category': category,
      'receipt_number': receiptNumber,
      'order_number': orderNumber,
      'item_photos': photos,
      'condition': condition,
      'reason_for_return': reasonForReturn,
      'is_online_purchase': isOnlinePurchase,
      'store_location': storeLocation,
      'status': status.value,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
    };
  }

  int get daysUntilDeadline {
    final now = DateTime.now();
    final difference = returnDeadline.difference(now).inDays;
    return difference < 0 ? 0 : difference;
  }

  bool get isUrgent => daysUntilDeadline <= 3;

  bool get isOverdue => DateTime.now().isAfter(returnDeadline);

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get statusDisplayName {
    switch (status) {
      case ReturnStatus.pending:
        return 'Pending';
      case ReturnStatus.inProgress:
        return 'In Progress';
      case ReturnStatus.completed:
        return 'Completed';
      case ReturnStatus.expired:
        return 'Expired';
    }
  }

  ReturnItem copyWith({
    String? id,
    String? itemName,
    String? brand,
    String? store,
    double? price,
    DateTime? purchaseDate,
    DateTime? returnDeadline,
    String? size,
    String? color,
    String? category,
    String? receiptNumber,
    String? orderNumber,
    List<String>? photos,
    String? condition,
    String? reasonForReturn,
    bool? isOnlinePurchase,
    String? storeLocation,
    ReturnStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? returnedAt,
  }) {
    return ReturnItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      brand: brand ?? this.brand,
      store: store ?? this.store,
      price: price ?? this.price,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      returnDeadline: returnDeadline ?? this.returnDeadline,
      size: size ?? this.size,
      color: color ?? this.color,
      category: category ?? this.category,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      orderNumber: orderNumber ?? this.orderNumber,
      photos: photos ?? this.photos,
      condition: condition ?? this.condition,
      reasonForReturn: reasonForReturn ?? this.reasonForReturn,
      isOnlinePurchase: isOnlinePurchase ?? this.isOnlinePurchase,
      storeLocation: storeLocation ?? this.storeLocation,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      returnedAt: returnedAt ?? this.returnedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReturnItem &&
        other.id == id &&
        other.itemName == itemName &&
        other.brand == brand &&
        other.store == store &&
        other.price == price &&
        other.purchaseDate == purchaseDate &&
        other.returnDeadline == returnDeadline &&
        other.size == size &&
        other.color == color &&
        other.category == category &&
        other.receiptNumber == receiptNumber &&
        other.orderNumber == orderNumber &&
        _listEquals(other.photos, photos) &&
        other.condition == condition &&
        other.reasonForReturn == reasonForReturn &&
        other.isOnlinePurchase == isOnlinePurchase &&
        other.storeLocation == storeLocation &&
        other.status == status &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.returnedAt == returnedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemName.hashCode ^
        brand.hashCode ^
        store.hashCode ^
        price.hashCode ^
        purchaseDate.hashCode ^
        returnDeadline.hashCode ^
        size.hashCode ^
        color.hashCode ^
        category.hashCode ^
        receiptNumber.hashCode ^
        orderNumber.hashCode ^
        photos.hashCode ^
        condition.hashCode ^
        reasonForReturn.hashCode ^
        isOnlinePurchase.hashCode ^
        storeLocation.hashCode ^
        status.hashCode ^
        notes.hashCode ^
        createdAt.hashCode ^
        returnedAt.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ReturnItem(id: $id, itemName: $itemName, status: $status, deadline: $returnDeadline)';
  }
}
