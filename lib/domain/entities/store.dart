class Store {
  final String id;
  final String name;
  final String? logoUrl;
  final int defaultReturnPolicyDays;
  final String? website;
  final String? customerServicePhone;
  final String? customerServiceEmail;
  final List<StoreLocation> locations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Store({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.defaultReturnPolicyDays,
    this.website,
    this.customerServicePhone,
    this.customerServiceEmail,
    required this.locations,
    required this.createdAt,
    required this.updatedAt,
  });

  Store copyWith({
    String? id,
    String? name,
    String? logoUrl,
    int? defaultReturnPolicyDays,
    String? website,
    String? customerServicePhone,
    String? customerServiceEmail,
    List<StoreLocation>? locations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      defaultReturnPolicyDays:
          defaultReturnPolicyDays ?? this.defaultReturnPolicyDays,
      website: website ?? this.website,
      customerServicePhone: customerServicePhone ?? this.customerServicePhone,
      customerServiceEmail: customerServiceEmail ?? this.customerServiceEmail,
      locations: locations ?? this.locations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Store &&
        other.id == id &&
        other.name == name &&
        other.logoUrl == logoUrl &&
        other.defaultReturnPolicyDays == defaultReturnPolicyDays &&
        other.website == website &&
        other.customerServicePhone == customerServicePhone &&
        other.customerServiceEmail == customerServiceEmail &&
        _listEquals(other.locations, locations) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        logoUrl.hashCode ^
        defaultReturnPolicyDays.hashCode ^
        website.hashCode ^
        customerServicePhone.hashCode ^
        customerServiceEmail.hashCode ^
        locations.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
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
    return 'Store(id: $id, name: $name, returnPolicyDays: $defaultReturnPolicyDays)';
  }
}

class StoreLocation {
  final String id;
  final String storeId;
  final String name;
  final String address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final Map<String, String>? openingHours; // e.g., {"monday": "9:00-18:00"}

  const StoreLocation({
    required this.id,
    required this.storeId,
    required this.name,
    required this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.openingHours,
  });

  String get fullAddress {
    final parts = <String>[
      address,
      if (city != null) city!,
      if (state != null) state!,
      if (zipCode != null) zipCode!,
      if (country != null) country!,
    ];
    return parts.join(', ');
  }

  StoreLocation copyWith({
    String? id,
    String? storeId,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    Map<String, String>? openingHours,
  }) {
    return StoreLocation(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreLocation &&
        other.id == id &&
        other.storeId == storeId &&
        other.name == name &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode &&
        other.country == country &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.phoneNumber == phoneNumber &&
        _mapEquals(other.openingHours, openingHours);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        storeId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zipCode.hashCode ^
        country.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        phoneNumber.hashCode ^
        openingHours.hashCode;
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'StoreLocation(id: $id, name: $name, address: $address)';
  }
}
