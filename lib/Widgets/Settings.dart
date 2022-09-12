import 'dart:convert';

import 'package:first_app/Widgets/TypeSetting.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  String className;
  String classLevel;
  bool open;
  Function() changeOpen;
  List typesList;
  List editableTypesList;
  void Function(String type) addType;
  void Function(String type, int weight) deleteType;
  void Function(String type, String oldName) changeType;
  void Function() saveWeights;
  void Function(String newClassLevel) changeClassLevel;

  Settings(
    this.className,
    this.classLevel,
    this.open,
    this.changeOpen,
    this.typesList,
    this.addType,
    this.deleteType,
    this.changeType,
    this.editableTypesList,
    this.saveWeights,
    this.changeClassLevel,
  );
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool weightSumError = false;

  Future openNewTypeDialog() {
    var typeNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Add Type',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 80,
          child: Column(
            children: [
              TextField(
                maxLength: 30,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Type Name',
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
                controller: typeNameController,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.addType(typeNameController.text);
              Navigator.pop(context);
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

  Future openWeightErrorDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Weight Sum Error',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 80,
          child: Text(
            'Please adjust type weights so that they sum to 100 before performing this action.',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openMaxTypesDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Maximum Types Reached',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 60,
          child: Text(
            'The maximum number of types allowed is 12.',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openMinTypesDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Minimum Types Reached',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 60,
          child: Text(
            'You must have at least one type',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  void editTypesList(String type, int weight) {
    for (var item in widget.typesList) {
      if (item[0] == type) {
        item[1] = weight;
      }
    }
  }

  void errorCheckWeights() {
    int sum = 0;
    for (var type in widget.typesList) {
      sum += (type[1]) as int;
    }
    if (sum != 100) {
      setState(() {
        weightSumError = true;
      });
    } else {
      setState(() {
        weightSumError = false;
        widget.saveWeights();
      });
    }
  }

  Future openDeleteWarningDialog(BuildContext biggerContext) {
    String truncatedClassName = (widget.className.length <= 20)
        ? widget.className
        : '${widget.className.substring(0, 20)}...';
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Delete Class',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 100,
          child: Text(
            "Are you sure you want to delete the class '" +
                truncatedClassName +
                "'? Deleting a class will permanently delete all the data saved within the class.",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
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
                Navigator.pop(biggerContext, 'delete');
              },
              child: Text(
                'Delete',
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
    var mediaQuery = MediaQuery.of(context);
    final ScrollController scrollController = ScrollController();

    return Padding(
      padding: EdgeInsets.only(top: 58),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: widget.open ? 427 : 0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(66, 66, 66, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(255, 45, 45, 45),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: Color.fromRGBO(66, 66, 66, 1),
              blurRadius: 5,
              offset: Offset(0, -3),
            )
          ],
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: widget.open ? mediaQuery.size.width : 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 5),
                    child: Divider(
                      height: 15,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      thickness: 2,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 16),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: widget.open ? 24 : 0,
                    child: Row(
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: AnimatedContainer(
                              alignment: Alignment.centerRight,
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.only(right: 24),
                              child: Image.asset(
                                'Assets/images/xOutButton.png',
                                scale: 2,
                              ),
                            ),
                            onTap: () {
                              if (weightSumError) {
                                openWeightErrorDialog();
                              } else {
                                setState(() {
                                  widget.changeOpen();
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 21 : 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 3),
                        child: Text(
                          'Class Weighting',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 52 : 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 24, bottom: 16),
                        child: SizedBox(
                          height: 36,
                          width: 120,
                          child: Card(
                            color: Color.fromRGBO(66, 66, 66, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                width: 1.5,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Container(
                                child: DropdownButton<String>(
                                  dropdownColor: Color.fromRGBO(66, 66, 66, 1),
                                  value: widget.classLevel,
                                  underline: Container(height: 0),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 32),
                                    child: const Icon(
                                      Icons.arrow_downward,
                                      size: 20,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    widget.classLevel = newValue.toString();
                                    setState(() {
                                      widget.changeClassLevel(
                                        newValue.toString(),
                                      );
                                    });
                                  },
                                  items: <String>[
                                    'CP2',
                                    'CP1',
                                    'Honors',
                                    'AP',
                                    ''
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 27 : 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 10),
                        child: Text(
                          'Assignments',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 22 : 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 3),
                    child: Row(
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 105),
                          child: Text(
                            'Weight',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 10,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 140 : 0,
                  child: ListView.builder(
                    itemCount: widget.typesList.length,
                    itemBuilder: (context, index) => TypeSetting(
                      widget.typesList[index][0],
                      widget.typesList[index][1],
                      widget.deleteType,
                      widget.changeType,
                      editTypesList,
                      errorCheckWeights,
                      weightSumError,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 40 : 0,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 24, bottom: 0, top: 2),
                        child: FloatingActionButton(
                          onPressed: () {
                            if (widget.typesList.length >= 12) {
                              openMaxTypesDialog();
                            } else if (widget.typesList.length <= 1) {
                              openMinTypesDialog();
                            } else {
                              if (weightSumError) {
                                openWeightErrorDialog();
                              } else {
                                openNewTypeDialog();
                              }
                            }
                          },
                          child: Image.asset(
                            'Assets/images/roundAddButton.png',
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.open ? 45 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: GestureDetector(
                          child: Container(
                            width: 120,
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                'Delete Class',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Color.fromRGBO(252, 48, 48, 1),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            openDeleteWarningDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
