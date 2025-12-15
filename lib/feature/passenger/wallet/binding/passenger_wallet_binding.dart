import 'package:get/get.dart';
import '../controller/passenger_wallet_controller.dart';

class PassengerWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerWalletController>(() => PassengerWalletController());
  }
}
