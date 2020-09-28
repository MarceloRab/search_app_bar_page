import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_1);
                },
                child: Text(
                  'Ir para SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_2);
                },
                child: Text(
                  'Ir para SearchStreamPage',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
