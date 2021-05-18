import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/models/user_profile_model.dart';

class ActivateAccount extends StatefulWidget {
  @override
  _ActivateAccountState createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  // Color fColor;
  Color secColor = Colors.black;
  Color thColor = Colors.black;
  var _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    Future getUsers() async {
      return await _db
          .collection("users")
          .where('active', whereIn: ['active', 'not active'])
          .get();
    }

    Future changeUserActivity({userId, String active}) async {
      await _db
          .collection("users")
          .doc(userId)
          .update({"active": active}).whenComplete(() => print("done"));
    }

    profileCard(UserProfile user) {
      var fColor = user.active == 'active'
          ? Colors.greenAccent[400]
          : user.active == 'not active'
              ? Colors.red[400]
              : Colors.black;
      return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Colors.lightGreen[100],
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(15),
        height: 190,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage('images/7cc7a630624d20f7797cb4c8e93c09c1.png'),
                  maxRadius: 43,
                ),
                Icon(
                  Icons.wb_incandescent_outlined,
                  color: fColor,
                  size: 40,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    '${user.name.length < 1 ? user.email : user.name}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Activate Account'),
                  onPressed: () {
                    changeUserActivity(userId: user.id, active: 'active')
                        .then((_) {
                      setState(() {
                        fColor = Colors.greenAccent[400];
                      });
                      return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 10,
                          content: Text('Account is  Activated'),
                        ),
                      );
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Deactivate Account'),
                  onPressed: () {
                    changeUserActivity(userId: user.id, active: 'not active')
                        .then(
                      (_) {
                        setState(() {
                          fColor = Colors.red[400];
                        });
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Account is  Deactivated'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Activate Account'),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unknown error occurred'),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<UserProfile> users = querySnapshot.docs
                .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
                .toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return profileCard(users[index]);
              },
            );
          } else
            return Center(
              child: Text("Loading..."),
            );
        },
      ),
    );
  }
}

///same code with stream builder
// return Scaffold(
// appBar: AppBar(
// title: Text('Activate Account'),
// ),
// body: StreamBuilder<QuerySnapshot>(
// stream: getUsersStream(),
// builder: (context, snapshot) {
// print(snapshot.data.docs[0].data()['active']);
// if (!snapshot.hasData)
// return Center(
// child: CircularProgressIndicator(
// backgroundColor: Colors.deepPurple,
// ));
// List<UserProfile> users = snapshot.data.docs
//     .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
//     .toList();
// return ListView.builder(
// itemCount: users.length,
// itemBuilder: (BuildContext context, int index) {
// return profileCard(users[index]);
// },
// );
// },
// ),);
// }
// }
