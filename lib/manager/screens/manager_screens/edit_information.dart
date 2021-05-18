import 'package:flutter/material.dart';
import 'package:grocery_admin/manager/screens/manager_screens/change_display_name_screen.dart';
import 'package:grocery_admin/manager/screens/manager_screens/change_email_screen.dart';
import 'package:grocery_admin/manager/screens/manager_screens/change_password_screen.dart';
import 'package:grocery_admin/manager/screens/manager_screens/change_phone_screen.dart';
class EditInformation extends StatefulWidget {
  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Text('Edit Information',style: TextStyle(color: Colors.white),),
      ),
      body:buildEditAccountExpansionTile(context) ,
    );
  }
  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.all(15),
      leading: Icon(Icons.person,size: 35,),
      title: Text(
        "Edit Account",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      children: [
        SizedBox(height: 15,),
        ListTile(
          title: Text(
            "Change Display Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayNameScreen(),
                ));
          },
        ),        SizedBox(height: 15,),

        ListTile(
          title: Text(
            "Change Phone Number",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePhoneScreen(),
                ));
          },
        ),        SizedBox(height: 15,),

        ListTile(
          title: Text(
            "Change Email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailScreen(),
                ));
          },
        ),        SizedBox(height: 15,),

        ListTile(
          title: Text(
            "Change Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ));
          },
        ),
        // ListTile(
        //   title: Text(
        //     "Change Display Picture",
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 18,
        //     ),
        //   ),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ChangeDisplayPictureScreen(),
        //         ));
        //   },
        // ),

      ],
    );
  }

}

