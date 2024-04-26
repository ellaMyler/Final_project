import 'package:flutter/material.dart';

class Goals extends StatelessWidget {
  const Goals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals Page'),
      ),
      body: Center(
        child: Text(
          'This is the Goals Page',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}