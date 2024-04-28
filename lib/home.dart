import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';
import 'sdd_search.dart';

class JobWidget extends StatelessWidget {
  final String title;
  final String value;

  const JobWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
            ),
          ),
          const SizedBox(height: 30.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Builder(
        builder: (themeContext) {
          return MaterialApp(
            title: 'Job Finder',
            theme: ThemeProvider.themeOf(themeContext).data,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _searchResult = '';

  double devSelectedElevation = 10.0;
  double mlSelectedElevation = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: devSelectedElevation,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                setState(() {
                  devSelectedElevation = 10.0;
                  mlSelectedElevation = 1.0;
                });
              },
              child: Text('Developer Jobs'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: mlSelectedElevation,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                setState(() {
                  devSelectedElevation = 1.0;
                  mlSelectedElevation = 10.0;
                });
              },
              child: Text('AI and ML Jobs'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                          labelText: 'Enter City Name (<city>, <state>)'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _searchCity(_cityController.text);
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Visibility(
                    visible: _searchResult.isNotEmpty,
                    child: JobWidget(
                      title: 'Jobs in ' + _cityController.text,
                      value: _searchResult.isNotEmpty
                          ? _searchResult.split('\n')[1].trim()
                          : '',
                    ),
                  ),
                  Visibility(
                    visible: _searchResult.isNotEmpty,
                    child: JobWidget(
                      title: 'Number of Jobs',
                      value: _searchResult.isNotEmpty
                          ? _searchResult.split('\n')[2].trim()
                          : '',
                    ),
                  ),
                  Visibility(
                    visible: _searchResult.isNotEmpty,
                    child: JobWidget(
                      title: 'Mean Salary',
                      value: _searchResult.isNotEmpty
                          ? _searchResult.split('\n')[3].trim()
                          : '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchCity(String cityName) async {
    try {
      String jsonString = await rootBundle.loadString(
          'lib/assets/SoftwareDeveloperIncomeExpensesPerUSACity.json');
      final List<dynamic> cityDataList = json.decode(jsonString);

      final List<CityData> cityDataObjects = cityDataList
          .map((json) => CityData.fromJson(json))
          .cast<CityData>()
          .toList();

      final city = cityDataObjects.firstWhere(
          (data) => data.city.toLowerCase() == cityName.toLowerCase(),
          orElse: () => CityData(
                city: 'City not in Dataset',
                numSoftwareDeveloperJobs: 0,
                meanSoftwareDeveloperSalaryAdjusted: 0,
                costOfLivingPlusRentAvg: 0.0,
              ));

      setState(() {
        _searchResult = '''
          City: ${city.city}
          Number of Software Developer Jobs: ${city.numSoftwareDeveloperJobs}
          Mean Software Developer Salary: \$${city.meanSoftwareDeveloperSalaryAdjusted}
          Cost of Living Plus Rent avg: \$${city.costOfLivingPlusRentAvg}
        ''';
      });
    } catch (e) {
      setState(() {
        _searchResult = 'Error occurred: $e';
      });
    }
  }
}
