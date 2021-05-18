import 'package:flutter/material.dart';
import '../../../manager/screens/manager_screens/add_sucsessful.dart';
class AddInformation extends StatefulWidget {
  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  String name, email, phone, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text(
          'Add Information',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
         Padding(
           padding: const EdgeInsets.all(10),
           child: Column(
             children: [
               Text('Add Information',style: TextStyle(fontSize: 30),),
               SizedBox(
                 height: 30,
               ),
               addname(),
               SizedBox(
                 height: 25,
               ),
               addemail(),
               SizedBox(
                 height: 25,
               ),
               addphone(),
               SizedBox(
                 height: 25,
               ),
               addpassword(),
               SizedBox(
                 height: 25,
               ),
               ElevatedButton(
                   style: ButtonStyle(
                   ),
                   onPressed: (){
                    Duration(seconds: 2);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSucsessful()));
                   },
                   child: Text('ADD',style: TextStyle(fontSize: 25,color: Colors.white),))
             ],
           ),
         )
        ],
      ),
    );
  }

  Widget addname() {
    return TextFormField(
      onChanged: (value) {
        name = value;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter name",
        labelText: "name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget addemail() {
    return TextFormField(
      onChanged: (value) {
        email = value;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter email",
        labelText: "email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget addphone() {
    return TextFormField(
      onChanged: (value) {
        phone = value;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter number",
        labelText: "number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget addpassword() {
    return TextFormField(
      onChanged: (value) {
        password = value;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter password",
        labelText: "password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
