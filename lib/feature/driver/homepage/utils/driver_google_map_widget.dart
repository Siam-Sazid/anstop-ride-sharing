import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ride_sharing/feature/driver/homepage/controller/driver_home_controller.dart';

class DriverGoogleMapWidget extends StatelessWidget {
  const DriverGoogleMapWidget({Key? key}) : super(key: key);

  static final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverHomeScreenController>(
      builder: (controller) {
        // Log current state for debugging
        _logger.i('DriverGoogleMapWidget rebuild - markers: ${controller.markers.length}, polylines: ${controller.polylines.value.length}');

        // Get polylines value (reactive)
        final polylines = controller.polylines.value;

        return GoogleMap(
          initialCameraPosition: DriverHomeScreenController.defaultLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          markers: controller.markers,
          polylines: polylines,
          circles: controller.circles,
          onMapCreated: (GoogleMapController googleMapController) {
            _logger.i('GoogleMap onMapCreated called');
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
