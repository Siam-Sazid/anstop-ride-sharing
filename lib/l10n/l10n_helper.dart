import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/l10n/app_localizations.dart';

class AppLocalization {

  static AppLocalizations get tr {
    final context = Get.context;
    assert(context != null, 'Get.context is null. Make sure GetMaterialApp is used.');
    return AppLocalizations.of(context!)!;
  }

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
