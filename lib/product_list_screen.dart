import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String category;

  ProductListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Products')),
      body: ListView(
        children: [
          ListTile(title: Text('Product 1')),
          ListTile(title: Text('Product 2')),
          // Diğer ürünler burada eklenebilir
        ],
      ),
    );
  }
}
