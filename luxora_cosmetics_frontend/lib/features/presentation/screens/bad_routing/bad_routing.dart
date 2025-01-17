import 'package:flutter/material.dart';

class BadRoutingScreen extends StatelessWidget {
  const BadRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bad routing error..'),
      ),
    );
  }
}
