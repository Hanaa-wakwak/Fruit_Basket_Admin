import 'package:flutter/material.dart';

class AddSucsessful extends StatefulWidget {
  @override
  _AddSucsessfulState createState() => _AddSucsessfulState();
}

class _AddSucsessfulState extends State<AddSucsessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Text(
            'Added successfully',style: TextStyle(
            fontSize: 32,color: Colors.deepOrange
          ),
          ),
        ),
      ),
    );
  }
}
