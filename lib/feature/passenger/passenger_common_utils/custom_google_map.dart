import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/passenger/homepage/controller/home_page_controller.dart';

class PassengerGoogleMapWidget extends StatefulWidget {
  const PassengerGoogleMapWidget({Key? key}) : super(key: key);

  @override
  State<PassengerGoogleMapWidget> createState() => _PassengerGoogleMapWidgetState();
}

class _PassengerGoogleMapWidgetState extends State<PassengerGoogleMapWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (controller) {
        return GoogleMap(
          initialCameraPosition: HomePageController.defaultLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          markers: controller.markers,
          polylines: controller.polylines,
          onMapCreated: (GoogleMapController googleMapController) {
            controller.mapController = googleMapController;
            if (controller.currentPosition != null) {
              googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      controller.currentPosition!.latitude,
                      controller.currentPosition!.longitude,
                    ),
                    zoom: 15.0,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
