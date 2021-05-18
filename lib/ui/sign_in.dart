import 'package:flutter/material.dart';
import 'package:grocery_admin/helpers/project_configuration.dart';
import 'package:grocery_admin/manager/screens/manager_screens/manager_home.dart';
import 'package:grocery_admin/models/sign_in_model.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin/widgets/texts.dart';

class SignIn extends StatefulWidget {
  final SignInModel model;

  SignIn({@required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return ChangeNotifierProvider<SignInModel>(
      create: (BuildContext context) =>
          SignInModel(auth: auth, database: database),
      child: Consumer<SignInModel>(
        builder: (context, model, _) {
          return SignIn(
            model: model,
          );
        },
      ),
    );
  }

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool isAdmin = false;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode fullNameFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      body: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return true;
              },
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: FadeInImage(
                          image: AssetImage(ProjectConfiguration.logo),
                          placeholder: AssetImage(""),
                          width: 100,
                          height: 100,
                        ),
                      ),

                      ///Full name field
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 300),
                        child: widget.model.isSignedIn
                            ? SizedBox()
                            : TextFields.emailTextField(
                                themeModel: themeModel,
                                isLoading: widget.model.isLoading,
                                textEditingController: fullNameController,
                                focusNode: fullNameFocus,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.text,
                                labelText: "Full Name",
                                iconData: Icons.person_outline,
                                onSubmitted: () {
                                  _fieldFocusChange(
                                      context, fullNameFocus, emailFocus);
                                },
                                error: !widget.model.validName),
                      ),

                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validName &&
                                !widget.model.isSignedIn)
                            ? FadeIn(
                                child: Texts.helperText(
                                    "Please enter a valid name", Colors.red),
                              )
                            : SizedBox(),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFields.emailTextField(
                            themeModel: themeModel,
                            controller: emailController,
                            isLoading: widget.model.isLoading,
                            focusNode: emailFocus,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            labelText: "Email",
                            iconData: Icons.email,
                            onSubmitted: () {
                              _fieldFocusChange(
                                  context, emailFocus, passwordFocus);
                            },
                            error: !widget.model.validEmail),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validEmail)
                            ? FadeIn(
                                child: Texts.helperText(
                                    'Please enter a valid email', Colors.red),
                              )
                            : SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFields.emailTextField(
                            themeModel: themeModel,
                            controller: passwordController,
                            isLoading: widget.model.isLoading,
                            focusNode: passwordFocus,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.text,
                            obscureText: true,
                            labelText: "Password",
                            iconData: Icons.lock_outline,
                            onSubmitted: () {
                              widget.model.signInWithEmail(
                                  context,
                                  emailController.text,
                                  passwordController.text);
                              widget.model.createAccount(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                  fullNameController.text);
                            },
                            error: !widget.model.validPassword),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validPassword)
                            ? FadeIn(
                                child: Texts.helperText(
                                    'Please enter a valid password : don\'t forget numbers, special characters(@, # ...), capital letters',
                                    Colors.red),
                              )
                            : SizedBox(),
                      ),

                      ///confirm pass
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 300),
                        child: widget.model.isSignedIn
                            ? SizedBox()
                            : TextFields.emailTextField(
                                themeModel: themeModel,
                                isLoading: widget.model.isLoading,
                                textEditingController: confirmpassword,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.text,
                                labelText: "Confirm password",
                                iconData: Icons.person_outline,
                                onSubmitted: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please re-enter password';
                                  }
                                  print(passwordController.text);

                                  print(confirmpassword.text);

                                  if (passwordController.text !=
                                      confirmpassword.text) {
                                    return "Password does not match";
                                  }
                                },
                                error: !widget.model.validName),
                      ),

                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validName &&
                                !widget.model.isSignedIn)
                            ? FadeIn(
                                child: Texts.helperText(
                                    "Please enter same password", Colors.red),
                              )
                            : SizedBox(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            Checkbox(
                                checkColor: Colors.red,
                                value: isAdmin,
                                onChanged: (val) {
                                  setState(() {
                                    isAdmin = val;
                                  });
                                }),
                            SizedBox(
                              width: 30,
                            ),
                            Text("Im Manager"),
                          ],
                        ),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validPassword)
                            ? FadeIn(
                                child: Texts.helperText(
                                    'Please enter a valid password : don\'t forget numbers, special characters(@, # ...), capital letters',
                                    Colors.red),
                              )
                            : SizedBox(),
                      ),
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 300),
                        child: widget.model.isLoading
                            ? Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Buttons.button(
                                color: themeModel.accentColor,
                                widget:
                                    Texts.headline3("SIGN IN", Colors.white),
                                function: () {
                                  if (isAdmin == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MangerHome()));
                                  }
                                  //Sign In function
                                  widget.model.signInWithEmail(
                                      context,
                                      emailController.text,
                                      passwordController.text);
                                },
                              ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: !widget.model.isLoading
                                  ? () {
                                      //Clear textFields data if switching to create account or signIn
                                      widget.model.changeSignStatus();

                                      fullNameController.clear();
                                      emailController.clear();
                                      passwordController.clear();
                                      fullNameFocus.unfocus();
                                      emailFocus.unfocus();
                                      passwordFocus.unfocus();
                                    }
                                  : null,
                              child: Texts.headline3(
                                  widget.model.isSignedIn
                                      ? "Create Account"
                                      : "Sign In",
                                  themeModel.textColor),
                            )),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
