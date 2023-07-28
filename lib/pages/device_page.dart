// device_page.dart
import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设备'),
      ),
      body: Material(
        color: Colors.grey,
        child: Column(
          children: [
            SizedBox(
                height: 120,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径
                    ),
                    margin: EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {
                          print('Container 被点击了');
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Row(
                            children: [
                              Image.asset("assets/device.png"),
                              Expanded(
                                child: Container(
                                  color: Colors.green[500],
                                  padding: EdgeInsets.all(10),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.white,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Connect to your",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Core",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))),
          ],
        ),
      ),
    );
  }
}
