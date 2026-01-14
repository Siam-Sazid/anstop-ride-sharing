class GetTripDetailsModel {
  final int statusCode;
  final String message;
  final TripDetailsData data;

  GetTripDetailsModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GetTripDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetTripDetailsModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: TripDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class TripDetailsData {
  final String id;
  final DriverInfo driverId;
  final LocationInfo pickup;
  final LocationInfo destination;
  final String distance;
  final int baseFare;
  final int finalFare;
  final DateTime createdAt;

  TripDetailsData({
    required this.id,
    required this.driverId,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.baseFare,
    required this.finalFare,
    required this.createdAt,
  });

  factory TripDetailsData.fromJson(Map<String, dynamic> json) {
    return TripDetailsData(
      id: json['_id'] ?? '',
      driverId: DriverInfo.fromJson(json['driverId'] ?? {}),
      pickup: LocationInfo.fromJson(json['pickup'] ?? {}),
      destination: LocationInfo.fromJson(json['destination'] ?? {}),
      distance: json['distance'] ?? '',
      baseFare: json['baseFare'] ?? 0,
      finalFare: json['finalFare'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class DriverInfo {
  final String id;
  final String name;
  final String? profilePicture;

  DriverInfo({
    required this.id,
    required this.name,
    this.profilePicture,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }
}

class LocationInfo {
  final String name;
  final List<double> coordinates;
  final String id;

  LocationInfo({
    required this.name,
    required this.coordinates,
    required this.id,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      id: json['_id'] ?? '',
    );
  }
}
