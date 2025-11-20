import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/splash_screen/driver_auth_selection_screen.dart';
import 'package:ride_sharing/feature/splash_screen/passenger_auth_selection_screen.dart';

import '../../app/utils/app_colors.dart';
import 'package:get/get.dart';
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/cuate.png', // Replace with your convertible car asset
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'WELCOME TO DURRAH',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Seamless, affordable, and reliable ride-sharing at your fingertips.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle passenger role selection
                  // Navigate to passenger dashboard or next step
                  Get.to(PassengerAuthSelectionScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 10),
                    Text('As a Passenger'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () {
                  Get.to(DriverAuthSelectionScreen());

                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green[800],
                  side: BorderSide(color: Colors.green[800]!),
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.directions_car_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Driver'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}