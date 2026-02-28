class MyRideModel {
  final String id;
  final Driver driver;
  final Location? pickup;
  final Location? destination;
  final String distance;
 // final int baseFare;
 // final int finalFare;
  final double fare;
  final DateTime createdAt;

  MyRideModel({
    required this.id,
    required this.driver,
    required this.pickup,
    required this.destination,
    required this.distance,
   // required this.baseFare,
  //  required this.finalFare,
    required this.createdAt,
    required this.fare
  });

  factory MyRideModel.fromJson(Map<String, dynamic> json) {
    return MyRideModel(
      id: json['_id'],
      driver: Driver.fromJson(json['driverId']),
      pickup: json['pickup'] != null
          ? Location.fromJson(json['pickup'])
          : null,
      destination: json['destination'] != null
          ? Location.fromJson(json['destination'])
          : null,
      distance: json['distance'],
    //  baseFare: json['baseFare'],
    //  finalFare: json['finalFare'],
      fare: (json['fare'] as num).toDouble(),
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
