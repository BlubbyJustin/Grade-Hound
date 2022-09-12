import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Pages/GpaPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

// run on real device: flutter run lib/main.dart

import '../Authentication/auth_service.dart';
import '../Widgets/ClassList.dart';
import '../Widgets/ClassCard.dart';
import '../Widgets/BottomNavBar.dart';
import 'ClassPage.dart';
import 'GpaPage.dart';

class HomePage extends StatefulWidget {
  static const pageRoute = '/class_page';
  final String uid;

  HomePage(this.uid); //re make the tables and start the fuck over

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _myPage = PageController(initialPage: 0);

  List<ClassCard> listOfAddedClasses = [];

  bool isLoading = false;

  bool isFirstRound = true;

  String webService = 'https://gtb-doqj7ebw4q-uc.a.run.app';

  String name = 'Welcome!';

  void initClassList() async {
    isFirstRound = false;
    if (listOfAddedClasses.length == 0) {
      isLoading = true;
      var url = Uri.parse('$webService/fetchClassData');

      await http.post(url, body: json.encode({'userId': widget.uid}));
      var response = await http.get(url);
      var decoded = json.decode(response.body);
      if (decoded.length != 0) {
        //print(widget.uid);
        for (var row in decoded) {
          bool aboveTarget = true;
          if (double.parse(row['currentGrade'].toString()).round() >=
              double.parse(row['targetGrade'].toString())) {
            aboveTarget = true;
          } else {
            aboveTarget = false;
          }
          listOfAddedClasses.add(
            new ClassCard(
              row['classId'],
              row['userId'],
              row['className'],
              row['targetGrade'],
              double.parse(row['currentGrade']),
              deleteClass,
              aboveTarget,
              name,
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void getFirstName() async {
    var url = Uri.parse('$webService/getFirstName');
    var response = await http.post(
      url,
      body: json.encode({
        'userId': widget.uid,
      }),
    );
    var formattedResponse = json.decode(response.body);
    var firstName = formattedResponse['firstName'];

    firstName = (firstName.length <= 20)
        ? firstName
        : '${firstName.substring(0, 19)}... ';
    setState(() {
      name = 'Hi ' + firstName + '!';
    });
  }

  void addClass(className, targetGrade) async {
    var url = Uri.parse('$webService/addClass');
    var response = await http.post(
      url,
      body: json.encode({
        'userId': widget.uid,
        'className': className,
        'targetGrade': targetGrade,
      }),
    );
    var formattedResponse = json.decode(response.body);
    var classId = formattedResponse['classId'];
    setState(() {
      listOfAddedClasses.add(new ClassCard(
        classId,
        widget.uid,
        className,
        targetGrade,
        0,
        deleteClass,
        false,
        name,
      ));
    });
  }

  void deleteClass(int classId) async {
    var url = Uri.parse('$webService/deleteClass');
    var response = await http.post(
      url,
      body: json.encode({
        'userId': widget.uid,
        'classId': classId,
      }),
    );

    listOfAddedClasses.length = 0;
    if (listOfAddedClasses.length == 0) {
      var url = Uri.parse('$webService/fetchClassData');

      await http.post(url, body: json.encode({'userId': widget.uid}));
      var response = await http.get(url);
      var decoded = json.decode(response.body);
      if (decoded.length != 0) {
        //print(widget.uid);
        for (var row in decoded) {
          bool aboveTarget = true;
          if (double.parse(row['currentGrade'].toString()).round() >=
              double.parse(row['targetGrade'].toString())) {
            aboveTarget = true;
          } else {
            aboveTarget = false;
          }
          listOfAddedClasses.add(
            new ClassCard(
              row['classId'],
              row['userId'],
              row['className'],
              row['targetGrade'],
              double.parse(row['currentGrade']),
              deleteClass,
              aboveTarget,
              name,
            ),
          );
        }
      }
    }
    setState(() {});
  }

  Future openDialog() {
    var classNameController = TextEditingController();
    var targetGradeController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Add Class',
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        content: Container(
          height: 96,
          child: Column(
            children: [
              TextField(
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                maxLength: 30,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Class name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(216, 194, 251, 1),
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),
                ),
                controller: classNameController,
              ),
              TextField(
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                maxLength: 3,
                decoration: InputDecoration(
                  hintText: 'Target grade',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(216, 194, 251, 1),
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),
                  counterText: '',
                ),
                controller: targetGradeController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addClass(classNameController.text,
                  int.parse(targetGradeController.text));
              /////////////////////////////////////////MAKE SURE THEY CAN"T ADD A CLASS WITH SAME NAME AS ONE ALREADY ADDED!!!
              Navigator.of(context).pop();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openlogoutWarningDialog(BuildContext biggerContext) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Center(
          child: Text(
            'Log Out',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        content: Container(
          height: 15,
          child: Text(
            "Are you sure you want to log out?",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 14,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 17, bottom: 6),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(216, 194, 251, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Log out',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color.fromRGBO(66, 66, 66, 1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17, bottom: 6),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(216, 194, 251, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color.fromRGBO(66, 66, 66, 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstRound) {
      getFirstName();
      initClassList();
    }
    var mediaQuery = MediaQuery.of(context);

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(66, 66, 66, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          height: mediaQuery.size.height * 0.13,
          child: CupertinoNavigationBar(
            backgroundColor: Color.fromRGBO(66, 66, 66, 1),
            middle: Text(
              name,
              style: Theme.of(context).textTheme.headline2,
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                child: Image.asset(
                  'Assets/images/logoutButton.png',
                  scale: 2.5,
                ),
                onTap: () {
                  openlogoutWarningDialog(context);
                },
              ),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 24, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: mediaQuery.size.width * 0.55,
                      height: mediaQuery.size.height * 0.065,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Classes",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              isLoading
                  ? Expanded(
                      child: Column(
                      children: [
                        Container(
                          height: mediaQuery.size.height * 0.3,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(216, 194, 251, 1),
                          ),
                        ),
                      ],
                    ))
                  : Expanded(
                      child: ClassList(
                        listOfAddedClasses,
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 90,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => openDialog(),
            child: Image.asset(
              'Assets/images/roundAddButton.png',
              scale: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: Container(
      //   height: 60,
      //   child: BottomAppBar(
      //     color: Color.fromRGBO(42, 42, 42, 1),
      //     shape: CircularNotchedRectangle(),
      //     notchMargin: 1,
      //     // child: Row(
      //     //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //   children: <Widget>[
      //     //     Container(
      //     //       width: mediaQuery.size.width * 0.5,
      //     //     ),
      //     //     ElevatedButton(
      //     //       child: Text(
      //     //         'Logout ma boi',
      //     //       ),
      //     //       onPressed: () {
      //     //         authService.signOut();
      //     //       },
      //     //     ),
      //     //   ],
      //     // ),
      //   ),
      // ),
    );
  }
}
