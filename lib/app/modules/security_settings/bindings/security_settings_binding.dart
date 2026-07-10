import 'package:get/get.dart';
import '../controllers/security_settings_controller.dart';

class SecuritySettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecuritySettingsController>(
      () => SecuritySettingsController(),
    );
  }
}
