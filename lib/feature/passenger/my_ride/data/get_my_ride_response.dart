class MyRideModel {
  final String id;
  final Driver driver;
  final Location pickup;
  final Location destination;
  final String distance;
  final int baseFare;
  final int finalFare;
  final DateTime createdAt;

  MyRideModel({
    required this.id,
    required this.driver,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.baseFare,
    required this.finalFare,
    required this.createdAt,
  });

  factory MyRideModel.fromJson(Map<String, dynamic> json) {
    return MyRideModel(
      id: json['_id'],
      driver: Driver.fromJson(json['driverId']),
      pickup: Location.fromJson(json['pickup']),
      destination: Location.fromJson(json['destination']),
      distance: json['distance'],
      baseFare: json['baseFare'],
      finalFare: json['finalFare'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
class Driver {
  final String id;
  final String name;
  final String? profilePicture;

  Driver({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }
}
class Location {
  final String id;
  final String name;
  final List<double> coordinates;

  Location({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'],
      name: json['name'],
      coordinates: List<double>.from(
        json['coordinates'].map((e) => e.toDouble()),
      ),
    );
  }
}
