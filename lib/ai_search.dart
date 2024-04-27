import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(JobSearchApp());
}

class JobSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Search',
      home: JobSearchScreen(),
    );
  }
}


class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late List<dynamic> _jobs = [];
  late List<dynamic> _filteredJobs = [];
  late String _selectedSkill = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final String response =
    await rootBundle.loadString('lib/assets/csvjson.json');
    final data = await json.decode(response);
    setState(() {
      _jobs = data;
      _filteredJobs = _jobs;
    });
  }

  void _filterJobs(String query) {
    if (query.isNotEmpty) {
      List<dynamic> tempList = [];
      _jobs.forEach((job) {
        List<dynamic> skills = job['Identified_Skills'];
        if (skills.contains(query)) {
          tempList.add(job);
        }
      });
      setState(() {
        _filteredJobs = tempList;
      });
      return;
    } else {
      setState(() {
        _filteredJobs = _jobs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _selectedSkill = value;
                      _filterJobs(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by skill',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton( // Add a button to apply the filter
                  onPressed: () {
                    _filterJobs(_selectedSkill);
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return ListTile(
                  title: Text(job['Title']),
                  subtitle: Text(job['Company']),
                  onTap: () {
                    // Navigate to job details screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

