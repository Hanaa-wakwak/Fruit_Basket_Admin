import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/helpers/validators.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/dialogs.dart';

class SignInModel with ChangeNotifier {
  final AuthBase auth;
  final Database database;
  bool validName = true;
  bool isLoading = false;
  bool isSignedIn = true;
  bool validEmail = true;
  bool validPassword = true;

  SignInModel({@required this.auth, @required this.database});


  void changeSignStatus() {
    isSignedIn = !isSignedIn;
    refreshTextFields();
    notifyListeners();
  }
  void refreshTextFields() {
    if (validName == false) {
      validName = true;
    }

    if (validEmail == false) {
      validEmail = true;
    }

    if (validPassword == false) {
      validPassword = true;
    }
  }
  
  ///Sign in with email function
  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      if (verifyInputs(context, email, password)) {
        isLoading = true;
        notifyListeners();

        await auth.signInWithEmailAndPassword(email, password);

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (isLoading) {
        isLoading = false;
        notifyListeners();
      }

      FirebaseAuthException exception = e;

      showDialog(
          context: context,
          builder: (context) =>
              Dialogs.error(context, messages: [exception.message]));
    }
  }
  

  //Check inputs and display errors
  bool verifyInputs(
    BuildContext context,
    String email,
    String password,
  ) {

    if (!Validators.email(email)) {
      validEmail = false;
    } else {
      validEmail = true;
    }

    if (!Validators.password(password)) {
      validPassword = false;
    } else {
      validPassword = true;
    }

    if (!validPassword || !validEmail) {
      notifyListeners();
    }

    return validEmail && validPassword;
  }

  void createAccount(BuildContext context, String text, String text2, String text3) {}
}
