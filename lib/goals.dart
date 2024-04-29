import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Goals extends StatefulWidget {
  const Goals({Key? key}) : super(key: key);

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<String> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _goals = prefs.getStringList('goals') ?? [];
    });
  }

  Future<void> _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', _goals);
  }

  void _toggleGoalCompletion(int index) {
    setState(() {
      _goals.removeAt(index);
      _saveGoals(); // Save goals when updated
    });
  }

  void _clearAllGoals() {
    setState(() {
      _goals.clear();
      _saveGoals(); // Save empty goals list
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String date = DateFormat('yMd').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Text('Today is $date'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _clearAllGoals();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeekBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(_goals[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          _toggleGoalCompletion(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkGoalsPage(goals: _goals)),
          ).then((goals) {
            if (goals != null) {
              setState(() {
                _goals = goals;
                _saveGoals(); // Save goals when updated
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildWeekBar() {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      children: List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        final isCurrentDay = day.day == now.day;

        return Expanded(
          child: InkWell(
            onTap: () {
              // Handle click action here
            },
            child: Container(
              height: 60,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isCurrentDay ? Colors.blue : Colors.blueGrey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    daysOfWeek[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrentDay ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrentDay ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class WorkGoalsPage extends StatelessWidget {
  final List<String> goals;

  WorkGoalsPage({required this.goals});

  @override
  Widget build(BuildContext context) {
    TextEditingController _goalController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Work Goals'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _goalController,
            decoration: InputDecoration(
              labelText: 'Enter your goal',
              suffixIcon: IconButton(
                onPressed: () {
                  if (_goalController.text.isNotEmpty) {
                    goals.add(_goalController.text);
                    Navigator.pop(context, goals);
                  }
                },
                icon: Icon(Icons.add),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(goals[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}