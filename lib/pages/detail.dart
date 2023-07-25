//detail.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailPage extends StatelessWidget {
  final String itemId;

  const DetailPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Text('Detail Page for Item $itemId'),
      ),
    );
  }
}