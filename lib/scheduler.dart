import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({Key? key}) : super(key: key);

  @override
  _SchedulerState createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Appointment>> _events = {}; // Map to store events/appointments

  final TextEditingController _appointmentController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduler Page'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` as well
                });
                _showAppointmentsPopup(selectedDay);
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                // Return events for the selected day
                return _events[day] ?? [];
              },
            ),
            if (_selectedDay != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selected Time: ${_selectedTime?.format(context) ?? "Not set"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _selectedTime = selectedTime;
                        });
                      }
                    },
                    child: const Text('Set Time'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Schedule an Appointment:',
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: _appointmentController,
                  decoration: const InputDecoration(
                    labelText: 'Appointment Details',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDay != null && _selectedTime != null) {
                    final appointment = Appointment(
                      time: _selectedTime!,
                      details: _appointmentController.text,
                    );
                    _events[_selectedDay!] = _events[_selectedDay!] ?? [];
                    _events[_selectedDay!]!.add(appointment);
                    _saveAppointments(); // Save appointments to disk
                    setState(() {
                      _appointmentController.clear();
                      _selectedTime = null;
                    });
                  } else {
                    // Handle case when either date or time is not selected
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please select both date and time for the appointment.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Schedule'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _appointmentController.dispose();
    super.dispose();
  }

  void _showAppointmentsPopup(DateTime day) {
    if (_events.containsKey(day) && _events[day]!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Appointments on ${_formatDate(day)}:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events[day]!.map((appointment) {
                return Row(
                  children: [
                    Expanded(
                      child: Text('${appointment.time.format(context)} - ${appointment.details}'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _events[day]!.remove(appointment);
                          _saveAppointments(); // Save appointments after removal
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? eventsMap = jsonDecode(prefs.getString('appointments') ?? '{}');
    setState(() {
      _events = eventsMap!.map((key, value) {
        return MapEntry(DateTime.parse(key), (value as List<dynamic>).map((e) => Appointment.fromJson(e)).toList());
      });
    });
  }

  void _saveAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('appointments', jsonEncode(_events.map((key, value) {
      return MapEntry(key.toString(), value.map((e) => e.toJson()).toList());
    })));
  }
}

class Appointment {
  final TimeOfDay time;
  final String details;

  Appointment({
    required this.time,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'details': details,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      details: json['details'],
    );
  }
}