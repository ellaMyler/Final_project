import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CityData {
  final String city;
  final int numSoftwareDeveloperJobs;
  final int meanSoftwareDeveloperSalaryAdjusted;
  final double costOfLivingPlusRentAvg;

  CityData({
    required this.city,
    required this.numSoftwareDeveloperJobs,
    required this.meanSoftwareDeveloperSalaryAdjusted,
    required this.costOfLivingPlusRentAvg,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      city: json['City'],
      numSoftwareDeveloperJobs: json['Number of Software Developer Jobs'],
      meanSoftwareDeveloperSalaryAdjusted: json['Mean Software Developer Salary (adjusted)'],
      costOfLivingPlusRentAvg: (json['Cost of Living Plus Rent avg'] is int)
          ? (json['Cost of Living Plus Rent avg'] as int).toDouble()
          : json['Cost of Living Plus Rent avg'], // Handle both int and double
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'City Data Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _searchResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter City Name'),
            ),
            ElevatedButton(
              onPressed: () {
                _searchCity(_cityController.text);
              },
              child: Text('Search'),
            ),
            const SizedBox(height: 20),
            Text(_searchResult),
          ],
        ),
      ),
    );
  }

  void _searchCity(String cityName) async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/SofwareDeveloperIncomeExpensesperUSACity.json');
      final List<dynamic> cityDataList = json.decode(jsonString);

      final List<CityData> cityDataObjects = cityDataList.map((json) => CityData.fromJson(json)).cast<CityData>().toList();

      final city = cityDataObjects.firstWhere(
            (data) => data.city.toLowerCase() == cityName.toLowerCase(),
          orElse: () => CityData(
            city: '',
            numSoftwareDeveloperJobs: -1,
            meanSoftwareDeveloperSalaryAdjusted: -1,
            costOfLivingPlusRentAvg: -1.0,
          )
      );
      if (city != null) {
        setState(() {
          _searchResult = '''
            City: ${city.city}
            Number of Software Developer Jobs: ${city.numSoftwareDeveloperJobs}
            Mean Software Developer Salary (adjusted): \$${city.meanSoftwareDeveloperSalaryAdjusted}
            Cost of Living Plus Rent avg: \$${city.costOfLivingPlusRentAvg}
          ''';
        });
      } else {
        setState(() {
          _searchResult = 'City not found.';
        });
      }
    } catch (e) {
      setState(() {
        _searchResult = 'Error occurred: $e';
      });
    }
  }
}
