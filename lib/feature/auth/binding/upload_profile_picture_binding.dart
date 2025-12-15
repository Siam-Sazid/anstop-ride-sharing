import 'package:get/get.dart';
import '../controller/upload_profile_picture_controller.dart';

class UploadProfilePictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadProfilePictureController>(() => UploadProfilePictureController());
  }
}
