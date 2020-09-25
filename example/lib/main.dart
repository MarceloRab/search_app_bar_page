import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "SearchAppBarGetx",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
