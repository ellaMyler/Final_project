import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Center(
        child: Text(
          'This is the Search Page',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}