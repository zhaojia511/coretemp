import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzsports/pages/detail.dart';

class HomePage extends StatelessWidget {

  final List<String> _items = const [
    'jump',
    'run',
    'weight',
    'isometric',
    'elastic',
  ];

  const HomePage({super.key});

  void _onItemPressed(BuildContext context, int index) {
    Get.to(DetailPage(itemId: _items[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(_items.length, (index) {
          return GestureDetector(
            onTap: () => _onItemPressed(context, index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage('assets/${_items[index]}_2x.png'),
                  size: 48.0,
                ),
                SizedBox(height: 8.0),
                Text(
                  _items[index],
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


