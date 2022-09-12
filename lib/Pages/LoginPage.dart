import 'package:first_app/Authentication/auth_service.dart';
import 'package:first_app/Authentication/wrapper.dart';
import 'package:first_app/Widgets/SignUpTf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import '../Authentication/user_model.dart';
import '../Widgets/LoginTf.dart';

class LoginPage extends StatefulWidget {
  static const pageRoute = '/login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void switchPage(BuildContext context) {
    Navigator.pushNamed(context, '/signUp_page');
  }

  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  bool emailError = false;
  bool passError = false;

  String emailErrorText = '';
  String passErrorText = '';

  bool buttonActivated = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    var mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
            height: mediaQuery.size.height * 0.13,
            child: CupertinoNavigationBar(
              backgroundColor: Color.fromRGBO(66, 66, 66, 1),
              middle: Text(
                'Grade-Hound',
                style: Theme.of(context).textTheme.headline2,
              ),
              border: Border(
                bottom: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height:
                    mediaQuery.size.height - (mediaQuery.size.height * 0.26),
                width: double.infinity,
                margin: EdgeInsets.only(left: 35, right: 35),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    LoginTf(' Email', 'Enter email...', emailCont, emailError,
                        emailErrorText, true),
                    LoginTf(' Password', 'Enter password...', passCont,
                        passError, passErrorText, false),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.54,
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                            buttonActivated
                                ? Color.fromRGBO(216, 194, 251, 1)
                                : Color.fromRGBO(216, 194, 251,
                                    1), //Color.fromRGBO(120, 120, 120, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (emailCont.text != '' && passCont.text != '') {
                            await authService.signIn(
                              emailCont.text,
                              passCont.text,
                            );
                            if (authService.loginErrorCode == 'invalid-email') {
                              setState(() {
                                emailError = true;
                                passError = false;
                                emailErrorText = 'Email is invalid';
                              });
                            } else if (authService.loginErrorCode ==
                                'user-not-found') {
                              setState(() {
                                emailError = true;
                                passError = false;
                                emailErrorText = 'User does not exist';
                              });
                            } else if (authService.loginErrorCode ==
                                'wrong-password') {
                              setState(() {
                                passError = true;
                                emailError = false;
                                passErrorText = 'Incorrect Password';
                              });
                            } else if (authService.loginErrorCode ==
                                'too-many-requests') {
                              setState(() {
                                passError = false;
                                emailError = true;
                                emailErrorText =
                                    'Too many attempts. Try again later';
                              });
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: buttonActivated
                                  ? Color.fromRGBO(66, 66, 66, 1)
                                  : Color.fromRGBO(66, 66, 66,
                                      1) //Color.fromRGBO(189, 189, 189, 1),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: mediaQuery.size.height * 0.035),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet? ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                          fontSize: 13,
                          color: Color.fromRGBO(171, 210, 255, 1),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          emailCont.text = '';
                          passCont.text = '';
                          emailError = false;
                          passError = false;
                        });
                        switchPage(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: mediaQuery.viewInsets.bottom * 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
