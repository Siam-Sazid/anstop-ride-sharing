import 'package:get/get.dart';
import '../controller/upload_documents_controller.dart';

class UploadDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadDocumentsController>(() => UploadDocumentsController());
  }
}
