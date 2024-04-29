import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';
import 'sdd_search.dart';
import 'compare_city.dart';

class JobWidget extends StatelessWidget {
  final String title;
  final String value;

  const JobWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
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
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18.0,
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
  final TextEditingController _citySearchController = TextEditingController();
  final TextEditingController _cityCompareController = TextEditingController();
  String _searchResult = '';
  String _compareResult = '';


  final TextEditingController _regionSearchController = TextEditingController();
  List<Map<String, String>> _searchResultRegion = [];

  double devSelectedElevation = 10.0;
  double mlSelectedElevation = 1.0;

  bool showRegionSearch = false;

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
                  showRegionSearch = false;
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
                  showRegionSearch = true;
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
              Visibility(
                visible: !showRegionSearch, //hide
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _citySearchController,
                        decoration: const InputDecoration(
                            labelText: 'Enter City Name'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _searchCity(_citySearchController.text);
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: !showRegionSearch,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityCompareController,
                        decoration: const InputDecoration(
                            labelText: "Enter City Name's"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _compareCity(_cityCompareController.text);
                      },
                      child: const Text('Compare'),
                    ),
                  ],
                ),
              ),

              //AI/ML Search
              Visibility(
                visible: showRegionSearch,
                // Show only when region search is active
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _regionSearchController,
                        decoration: const InputDecoration(
                            labelText: 'Enter Region (CA, NY)'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _searchRegion(_regionSearchController.text);
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Wrap(
                      children: [
                        Visibility(
                          visible: _searchResult.isNotEmpty,
                          child: JobWidget(
                            title: 'Jobs in:',
                            value: _searchResult
                                .split('\n')
                                .length > 0
                                ? _searchResult.split('\n')[0].trim()
                                : '',
                          ),
                        ),
                        Visibility(
                          visible: _searchResult.isNotEmpty,
                          child: JobWidget(
                            title: 'Number of Jobs',
                            value: _searchResult
                                .split('\n')
                                .length > 1
                                ? _searchResult.split('\n')[1].trim()
                                : '',
                          ),
                        ),
                        Visibility(
                          visible: _searchResult.isNotEmpty,
                          child: JobWidget(
                            title: 'Mean Salary',
                            value: _searchResult
                                .split('\n')
                                .length > 2
                                ? _searchResult.split('\n')[2].trim()
                                : '',
                          ),
                        ),
                        Visibility(
                          visible: _searchResult.isNotEmpty,
                          child: JobWidget(
                            title: 'Cost of Living',
                            value: _searchResult
                                .split('\n')
                                .length > 3
                                ? _searchResult.split('\n')[3].trim()
                                : '',
                          ),
                        ),
                      ],
                    )
                  ]
              ),
              const SizedBox(height: 40),
              // GridView for AI/ML
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showRegionSearch && _searchResultRegion.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Location: ${_searchResultRegion.first["Location"] ?? 'Not available'}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ..._searchResultRegion.map((job) => Column(
                  children: [
                    JobWidget(title: 'Company Name:', value: job["Company Name"] ?? "Not available"),
                    JobWidget(title: 'Job Title:', value: job["Job Title"] ?? "Not available"),
                    JobWidget(title: 'Job Salary:', value: job["Job Salary"] ?? "Not available"),
                    Divider(),
                  ],
                )).toList(),
              ],
            ),

              GridView.count(
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _searchResultRegion.map((job) {
                  return Wrap(
                    children: [
                      JobWidget(title: 'Location:', value: job["Location"] ?? "Not available"),
                      JobWidget(title: 'Company:', value: job["Company"] ?? "Not available"),
                      JobWidget(title: 'Job Title:', value: job["Job Title"] ?? "Not available"),
                      JobWidget(title: 'Job Salary:', value: job["Job Salary"] ?? "Not available"),
                    ],
                  );
                }).toList(),
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
      print('cityDataList: $cityDataList');

      final List<CityData> cityDataObjects = cityDataList
          .map((json) => CityData.fromJson(json))
          .cast<CityData>()
          .toList();
      print('cityDataObjects: $cityDataObjects');

      final city = cityDataObjects.firstWhere(
              (data) =>
          data.city
              .split(',')
              .first
              .toLowerCase()
              .trim() == cityName
              .toLowerCase()
              .split(',')
              .first
              .trim(),
          orElse: () =>
              CityData(
                city: 'City not in Dataset',
                numSoftwareDeveloperJobs: 0,
                meanSoftwareDeveloperSalaryAdjusted: 0,
                costOfLivingPlusRentAvg: 0.0,
              ));
      print('city: $city');

      setState(() {
        _searchResult = '''
          City: ${city.city}
          Number of Software Developer Jobs: ${city.numSoftwareDeveloperJobs}
          Mean Software Developer Salary: \$${city
            .meanSoftwareDeveloperSalaryAdjusted}
          Cost of Living Plus Rent avg: \$${city.costOfLivingPlusRentAvg}
        ''';
      });
    } catch (e) {
      setState(() {
        _searchResult = 'Error occurred: $e';
      });
    }
  }

  void _compareCity(String cityName1) async {
    try {
      String jsonString = await rootBundle.loadString(
          'lib/assets/SoftwareDeveloperIncomeExpensesPerUSACity.json');
      final List<dynamic> cityCompareList = json.decode(jsonString);
      print('cityCompareList: $cityCompareList');

      final List<CityCompare> cityCompareObjects = cityCompareList
          .map((json) => CityCompare.fromJson(json))
          .cast<CityCompare>()
          .toList();
      print('cityCompareObjects: $cityCompareObjects');

      final city = cityCompareObjects.firstWhere(
              (data) =>
          data.city
              .split(',')
              .first
              .toLowerCase()
              .trim() == cityName1
              .toLowerCase()
              .split(',')
              .first
              .trim(),
          orElse: () =>
              CityCompare(
                city: 'City not in Dataset',
                meanSoftwareDeveloperSalaryAdjusted: 0,
                localPurchasingPower: 0.0,
              ));
      print('city: $city');

      setState(() {
        _compareResult = '''
          City: ${city.city}
          Mean Software Developer Salary: \$${city
            .meanSoftwareDeveloperSalaryAdjusted}
          Mean Local Purchasing Power: \$${city.localPurchasingPower}
        ''';
      });
    } catch (e) {
      setState(() {
        _compareResult = 'Error occurred: $e';
      });
    }
  }

  void _searchRegion(String regionName) async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/AI_ML_Jobs.json');
      final List<dynamic> regionDataList = json.decode(jsonString);
      final List<RegionData> regionDataObjects = regionDataList
          .map((json) => RegionData.fromJson(json))
          .toList();

      List<Map<String, String>> matches = regionDataObjects.where((data) =>
      data.location?.toLowerCase().trim() == regionName.toLowerCase().trim()).map((data) => {
        "Location": data.location ?? 'Not available',
        "Company Name": data.company ?? 'Not available',
        "Job Title": data.title ?? 'Not available',
        "Job Salary": data.salary?.toString() ?? 'Not available',
      }).toList();

      setState(() {
        _searchResultRegion = matches;
      });
    } catch (e) {
      setState(() {
        _searchResultRegion = [];
      });
      print('Error occurred: $e');
    }
  }



}
