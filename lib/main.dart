import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Authentication/auth_service.dart';
import 'package:first_app/Authentication/wrapper.dart';
import 'package:first_app/Pages/ClassPage.dart';
import 'package:first_app/Pages/GpaPage.dart';
import 'package:first_app/Widgets/ClassCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Widgets/experiment.dart';
import 'Pages/SignUpPage.dart';
import 'Pages/LoginPage.dart';
import 'package:provider/provider.dart';
import 'Authentication/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //Provider<AuthService>(create: (_) => AuthService())

  void initState() {
    super.initState(); /////
    WidgetsBinding.instance!.addObserver(this);
    //FirebaseAuth.instance.signOut();
  }

  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Grade-Hound",
          theme: ThemeData(
            fontFamily: 'Inter',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline1: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 54,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  headline2: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromRGBO(216, 194, 251, 1),
                  ),
                  headline3: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(66, 66, 66, 1),
                  ),
                  headline4: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    color: Color.fromRGBO(66, 66, 66, 1),
                  ),
                  headline5: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  headline6: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Color.fromRGBO(120, 120, 120, 1),
                  ),
                  bodyText1: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  bodyText2: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  button: TextStyle(color: Colors.white),
                ),
          ),
          home: Wrapper(),
          routes: {
            //HomePage.pageRoute: (context) => HomePage(),
            ClassPage.pageRoute: (context) => ClassPage(),
            SignUpPage.pageRoute: (context) => SignUpPage(),
            LoginPage.pageRoute: (context) => LoginPage(),
          },
        ),
      ),
    );
  }
}
