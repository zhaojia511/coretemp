import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevicesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设备'),
      ),
      body: const Center(
        child: Text('设备列表'),
      ),
    );
  }
}