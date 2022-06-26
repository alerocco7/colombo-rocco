import 'package:flutter/material.dart';

class PredictionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction Page')),
      body: Center(
        child: ElevatedButton(
          child: const Text('To CalendarPage'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}