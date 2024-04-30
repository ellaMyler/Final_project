import 'package:flutter/material.dart';
import 'package:final_project/authentication.dart';
import 'package:final_project/login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Welcome'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthenticationHelper()
              .signOut()
              .then((_) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (contex) => Login()),
          ));
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}