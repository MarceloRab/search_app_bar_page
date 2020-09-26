import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';

class ConnectyWidget extends StatefulWidget {
  final Color color;

  const ConnectyWidget({
    Key key,
    this.color ,
  }) : super(key: key);

  @override
  _ConnectyWidgetState createState() => _ConnectyWidgetState();
}

class _ConnectyWidgetState extends State<ConnectyWidget> {
  ConnectyController _connectyController;

  @override
  void initState() {
    _connectyController = ConnectyController();
    super.initState();
  }

  @override
  void dispose() {
    _connectyController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_connectyController.isConnected) {
        return IconButton(
          onPressed: () {},
          icon: const Icon(Icons.signal_wifi_off),
          color: widget.color,
        );
      } else
        return const SizedBox.shrink();
    });
  }
}
