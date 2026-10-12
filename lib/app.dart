import 'package:flutter/material.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Clinic Appointment System',
      home: Scaffold(body: Center(child: Text('Clinic Appointment System'))),
    );
  }
}
