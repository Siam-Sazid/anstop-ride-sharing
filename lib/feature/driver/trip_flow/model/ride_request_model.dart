class RideRequestModel {
  final String rideId;
  final String riderId;
  final LocationData pickUp;
  final LocationData destination;
  final String distance;
  final double preferedFare;
  final String note;
  final List<String> rideNeeds;

  RideRequestModel({
    required this.rideId,
    required this.riderId,
    required this.pickUp,
    required this.destination,
    required this.distance,
    required this.preferedFare,
    required this.note,
    required this.rideNeeds,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      rideId: json['rideId'] ?? '',
      riderId: json['riderId'] ?? '',
      pickUp: LocationData.fromJson(json['pickUp'] ?? {}),
      destination: LocationData.fromJson(json['destination'] ?? {}),
      distance: json['distance']?.toString() ?? '0',
      preferedFare: (json['preferedFare'] ?? 0).toDouble(),
      note: json['note'] ?? '',
      rideNeeds: List<String>.from(json['rideNeeds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'riderId': riderId,
      'pickUp': pickUp.toJson(),
      'destination': destination.toJson(),
      'distance': distance,
      'preferedFare': preferedFare,
      'note': note,
      'rideNeeds': rideNeeds,
    };
  }
}

class LocationData {
  final String name;
  final List<double> coordinates;
  final String id;

  LocationData({
    required this.name,
    required this.coordinates,
    required this.id,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      name: json['name'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] ?? []).map((e) => (e as num).toDouble()),
      ),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'coordinates': coordinates,
      '_id': id,
    };
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}
