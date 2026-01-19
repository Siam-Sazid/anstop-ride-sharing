import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/driver/homepage/controller/driver_home_controller.dart';

class DriverGoogleMapWidget extends StatelessWidget {
  const DriverGoogleMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverHomeScreenController>(
      builder: (controller) {
        return Obx(() => GoogleMap(
          initialCameraPosition: DriverHomeScreenController.defaultLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          markers: controller.markers,
          polylines: controller.polylines.value, // Add polylines for navigation
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
        ));
      },
    );
  }
}
