import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
      ),
      body: Center(
        child: Text('Sepetiniz boş'),
      ),
    );
  }
}
