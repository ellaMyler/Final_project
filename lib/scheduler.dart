import 'package:flutter/material.dart';

class Scheduler extends StatelessWidget {
  const Scheduler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduler Page'),
      ),
      body: Center(
        child: Text(
          'This is the Scheduler Page',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}