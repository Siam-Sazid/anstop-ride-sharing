import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app.dart';
import 'package:ride_sharing/services/socket_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Socket Service
  await Get.putAsync<SocketIoService>(() async {
    final service = SocketIoService();
    await service.init();
    return service;
  });

  runApp(const RideSharingApp());
}