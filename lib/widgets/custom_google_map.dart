
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/homepage/passenger/controller/home_page_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find(); // Get the controller

    return GoogleMap(
      initialCameraPosition: HomePageController.defaultLocation,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      markers: controller.markers,  // Using the markers from the controller
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
  }
}
