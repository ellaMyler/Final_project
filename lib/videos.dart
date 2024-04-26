import 'package:flutter/material.dart';

class videos extends StatelessWidget {
  const videos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('videos Page'),
      ),
      body: Center(
        child: Text(
          'This is the videos Page',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}