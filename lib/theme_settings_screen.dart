import 'package:flutter/material.dart';

class ThemeSettingsScreen extends StatelessWidget {
  final Function toggleTheme;

  ThemeSettingsScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theme Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            toggleTheme();
            Navigator.pop(context);
          },
          child: Text('Toggle Theme'),
        ),
      ),
    );
  }
}
