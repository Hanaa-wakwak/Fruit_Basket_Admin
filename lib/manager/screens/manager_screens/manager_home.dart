import 'package:flutter/material.dart';
import 'package:grocery_admin/manager/screens/manager_screens/activate_account.dart';

import '../manager_screens/add_information.dart';
import '../manager_screens/edit_information.dart';

class MangerHome extends StatefulWidget {
  @override
  _MangerHomeState createState() => _MangerHomeState();
}

class _MangerHomeState extends State<MangerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Home',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .8,
            child: ElevatedButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => ActivateAccount()));
              },
              child: Text('Activate or De Activate Account'),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditInformation()));
                },
                child: Text('Edit Information'),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddInformation()));
                },
                child: Text('Add information'),
              ))
        ],
      ),
    );
  }
}
