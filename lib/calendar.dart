import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date and Time Entry',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      _showTimePicker(context, pickedDate);
    }
  }

  void _showTimePicker(BuildContext context, DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            selectedDate: pickedDate,
            selectedTime: pickedTime,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showDatePicker(context),
          child: Text('Open Calendar'),
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  ConfirmationPage({Key? key, required this.selectedDate, required this.selectedTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Date and Time'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Selected Date: ${selectedDate.toLocal()}'),
            Text('Selected Time: ${selectedTime.format(context)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            )
          ],
        ),
      ),
    );
  }
}
