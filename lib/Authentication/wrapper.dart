import 'package:first_app/Authentication/auth_service.dart';
import 'package:first_app/Pages/HomePage.dart';
import 'package:first_app/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<theUser?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<theUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final theUser? user = snapshot.data;
            return user == null
                ? LoginPage()
                : HomePage(user
                    .uid); //(user.uid); //maybe replace login page with a circular turny butthole page
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(216, 194, 251, 1),
                ),
              ),
            );
          }
        });
  }
}
