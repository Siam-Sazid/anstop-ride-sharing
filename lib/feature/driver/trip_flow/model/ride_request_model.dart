class RideRequestModel {
  final String rideId;
  final String riderId;
  final Rider rider;
  final LocationData pickUp;
  final LocationData destination;
  final String distance;
  final double fare;
  final String note;
  final List<String> rideNeeds;
  final String riderNumber;
  final String rideFor;

  RideRequestModel({
    required this.rideId,
    required this.riderId,
    required this.rider,
    required this.pickUp,
    required this.destination,
    required this.distance,
    required this.fare,
    required this.note,
    required this.rideNeeds,
    required this.riderNumber,
    required this.rideFor,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      rideId: json['rideId'] ?? '',
      riderId: json['riderId'] ?? '',
      rider: Rider.fromJson(json['rider'] ?? {}),
      pickUp: LocationData.fromJson(json['pickUp'] ?? {}),
      destination: LocationData.fromJson(json['destination'] ?? {}),
      distance: json['distance']?.toString() ?? '0',
      fare: (json['fare'] ?? 0).toDouble(),
      note: json['note'] ?? '',
      rideNeeds: List<String>.from(json['rideNeeds'] ?? []),
      riderNumber: json['riderNumber'] ?? '',
      rideFor: json['rideFor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'riderId': riderId,
      'rider': rider.toJson(),
      'pickUp': pickUp.toJson(),
      'destination': destination.toJson(),
      'distance': distance,
      'fare': fare,
      'note': note,
      'rideNeeds': rideNeeds,
      'riderNumber': riderNumber,
      'rideFor': rideFor,
    };
  }
}

class Rider {
  final String id;
  final String name;
  final double rating;
  final int totalReviews;

  Rider({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalReviews,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: (json['totalReviews'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'rating': rating,
      'totalReviews': totalReviews,
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
