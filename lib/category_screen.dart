import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Electronics'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductListScreen(category: 'Electronics')),
              );
            },
          ),
          // Diğer kategoriler burada eklenebilir
        ],
      ),
    );
  }
}
