import 'package:first_app/Widgets/AssDeletionWidget.dart';
import 'package:first_app/Widgets/SortButton.dart';
import 'package:first_app/Widgets/TypeBubble.dart';
import 'package:first_app/Widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widgets/FilterButton.dart';
import '../Widgets/AssCard.dart';
import '../Widgets/AssList.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class ClassPage extends StatefulWidget {
  static const pageRoute = '/class_page';

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  List<AssCard> listOfAssignments = [];
  AssList assignmentList = AssList([]);

  String webService = 'https://gtb-doqj7ebw4q-uc.a.run.app';

  List<Color> colorList = [
    Color.fromRGBO(255, 187, 185, 1),
    Color.fromRGBO(255, 193, 118, 1),
    Color.fromRGBO(255, 234, 41, 1),
    Color.fromRGBO(200, 240, 186, 1),
    Color.fromRGBO(171, 210, 255, 1),
    Color.fromRGBO(255, 176, 228, 1),
    Color.fromRGBO(219, 194, 165, 1),
    Color.fromRGBO(237, 196, 90, 1),
    Color.fromRGBO(231, 234, 110, 1),
    Color.fromRGBO(156, 238, 208, 1),
    Color.fromRGBO(187, 244, 244, 1),
    Color.fromRGBO(255, 142, 183, 1),
  ];

  bool selected = true;

  int classId = 0;
  String className = '';
  double currentGrade = 0.0;
  String classLevel = '';
  String userName = '';

  bool isLoading = false;

  bool isfirstRound = true;

  List typesList = [];
  List editableTypeList = [];
  List filteredTypeList = [];
  List<String> typeNameList = [];
  List<String> filteredTypeNameList = [];

  List<TypeBubble> typeBubblList = [];

  bool filterVisible = true;
  bool sortVisible = true;

  int currentSortType = 1;

  bool resetSort = false;
  bool resetFilter = false;

  bool settingsOpen = false;

  String dropdownvalue = '';

  void changeFilterVisibiity() {
    setState(() {
      filterVisible = !filterVisible;
    });
  }

  void changeSortVisibility() {
    setState(() {
      sortVisible = !sortVisible;
    });
  }

  void changeSettingsToClosed() {
    setState(() {
      settingsOpen = false;
    });
  }

  void sortAssignmentListNewToOld() {
    //does not accound for tthings being added same day, maybe convert all dates with hours seconds etc.
    setState(() {
      listOfAssignments.sort(
        (b, a) => DateTime.parse(a.date).compareTo(
          DateTime.parse(b.date),
        ),
      );
    });
  }

  void initPage() async {
    isfirstRound = false;
    if (listOfAssignments.length == 0 && typesList.length == 0) {
      isLoading = true;

      //init class level
      var url3 = Uri.parse('$webService/initClassLevel');
      await http.post(url3, body: json.encode({'classId': classId}));
      var response3 = await http.get(url3);
      var decoded3 = json.decode(response3.body);
      for (var row in decoded3) {
        classLevel = row['level'];
      }

      //init types
      var url2 = Uri.parse('$webService/initTypesList');
      await http.post(url2, body: json.encode({'classId': classId}));
      var response2 = await http.get(url2);
      var decoded2 = json.decode(response2.body);
      if (decoded2.length != 0) {
        for (var row in decoded2) {
          typesList.add([row['typeName'], row['weight']]);
          filteredTypeList.add([row['typeName'], row['weight']]);
        }
        for (var type in typesList) {
          typeNameList.add(type[0]);
          filteredTypeNameList.add(type[0]);
        }
      }

      //init assignments
      var url = Uri.parse('$webService/fetchAssignmentData');
      await http.post(url, body: json.encode({'classId': classId}));
      var response = await http.get(url);
      var decoded = json.decode(response.body);
      if (decoded.length != 0) {
        for (var row in decoded) {
          DateTime date = DateTime.parse(row['date']);
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(date).toString();
          listOfAssignments.add(
            new AssCard(
                row['assignmentId'],
                row['classId'],
                row['type'],
                row['name'],
                row['grade'],
                formattedDate,
                row['comment'],
                deleteAssignment,
                editAssignmentComment,
                colorList[typeNameList.indexOf(row['type'])]),
          );
        }
      }

      sortAssignmentListNewToOld();
      setState(() {
        assignmentList = AssList(listOfAssignments);
        isLoading = false;
      });
    }
  }

  void reInitPage() async {
    isfirstRound = false;
    isLoading = true;

    listOfAssignments.length = 0;
    //init assignments
    var url = Uri.parse('$webService/fetchAssignmentData');
    await http.post(url, body: json.encode({'classId': classId}));
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    if (decoded.length != 0) {
      for (var row in decoded) {
        DateTime date = DateTime.parse(row['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
        listOfAssignments.add(
          new AssCard(
              row['assignmentId'],
              row['classId'],
              row['type'],
              row['name'],
              row['grade'],
              formattedDate,
              row['comment'],
              deleteAssignment,
              editAssignmentComment,
              colorList[typeNameList.indexOf(row['type'])]),
        );
      }
    }

    sortAssignmentListNewToOld();
    setState(() {
      assignmentList = AssList(listOfAssignments);
      isLoading = false;
    });
  }

  void changeClassLevel(String newClassLevel) async {
    var url = Uri.parse('$webService/changeClassLevel');
    await http.post(
      url,
      body: json.encode({
        'classId': classId,
        'newClassLevel': newClassLevel,
      }),
    );
    classLevel = newClassLevel;
  }

  void addAssignment(type, name, grade, date, comment) async {
    //add to database
    var url = Uri.parse('$webService/addAssignment');
    var response = await http.post(
      url,
      body: json.encode({
        'classId': classId,
        'type': type,
        'name': name,
        'grade': grade,
        'date': date,
        'comment': comment,
      }),
    );

    //re-init to show all assignments
    setState(() {
      resetFilter = true;
      resetSort = true;
    });
    typesList.length = 0;
    filteredTypeList.length = 0;
    typeNameList.length = 0;
    filteredTypeNameList.length = 0;
    typeBubblList.length = 0;

    var url2 = Uri.parse('$webService/initTypesList');
    await http.post(url2, body: json.encode({'classId': classId}));
    var response2 = await http.get(url2);
    var decoded2 = json.decode(response2.body);
    if (decoded2.length != 0) {
      for (var row in decoded2) {
        typesList.add([row['typeName'], row['weight']]);
        filteredTypeList.add([row['typeName'], row['weight']]);
      }
      for (var type in typesList) {
        typeNameList.add(type[0]);
        filteredTypeNameList.add(type[0]);
      }
    }

    print(typesList.length);
    print(filteredTypeList.length);
    print(typeNameList.length);
    print(typeBubblList.length);

    listOfAssignments.length = 0;
    var url3 = Uri.parse('$webService/fetchAssignmentData');
    await http.post(url3, body: json.encode({'classId': classId}));
    var response3 = await http.get(url3);
    var decoded3 = json.decode(response3.body);
    if (decoded3.length != 0) {
      for (var row in decoded3) {
        DateTime date = DateTime.parse(row['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
        listOfAssignments.add(
          new AssCard(
              row['assignmentId'],
              row['classId'],
              row['type'],
              row['name'],
              row['grade'],
              formattedDate,
              row['comment'],
              deleteAssignment,
              editAssignmentComment,
              colorList[typeNameList.indexOf(row['type'])]),
        );
      }
    }
    setState(() {
      assignmentList = AssList(listOfAssignments);
    });
    recalcAverage();
  }

  void changeSortReset() {
    resetSort = false;
  }

  void changeFilterReset() {
    resetFilter = false;
  }

  void recalcAverage() async {
    var url = Uri.parse('$webService/recalcAverage');
    var response =
        await http.post(url, body: json.encode({'classId': classId}));
    var formattedResponse = json.decode(response.body);
    var newAverage = formattedResponse['newAverage'];
    setState(() {
      currentGrade = double.parse(newAverage);
    });
  }

  void addType(String type) async {
    var url = Uri.parse('$webService/addType');
    await http.post(
      url,
      body: json.encode(
        {
          'classId': classId,
          'typeName': type,
          'weight': 0,
        },
      ),
    );
    setState(() {
      resetFilter = true;
      resetSort = true;
    });
    typesList.length = 0;
    filteredTypeList.length = 0;
    typeNameList.length = 0;
    filteredTypeNameList.length = 0;
    typeBubblList.length = 0;

    var response = await http.get(url);
    var decoded = json.decode(response.body);
    setState(() {
      if (decoded.length != 0) {
        for (var row in decoded) {
          typesList.add([row['typeName'], row['weight']]);
          filteredTypeList.add([row['typeName'], row['weight']]);
        }
        for (var type in typesList) {
          typeNameList.add(type[0]);
          filteredTypeNameList.add(type[0]);
        }
      }
    });
    // listOfAssignments.length = 0;
    // var url2 = Uri.parse('$webService/fetchAssignmentData');
    // await http.post(url2, body: json.encode({'classId': classId}));
    // var response2 = await http.get(url2);
    // var decoded2 = json.decode(response2.body);
    // if (decoded2.length != 0) {
    //   for (var row in decoded2) {
    //     DateTime date = DateTime.parse(row['date']);
    //     String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
    //     listOfAssignments.add(
    //       new AssCard(
    //           row['assignmentId'],
    //           row['classId'],
    //           row['type'],
    //           row['name'],
    //           row['grade'],
    //           formattedDate,
    //           row['comment'],
    //           deleteAssignment,
    //           editAssignmentComment,
    //           colorList[typeNameList.indexOf(row['type'])]),
    //     );
    //   }
    // }
    // setState(() {
    //   assignmentList = AssList(listOfAssignments);
    // });
  }

  void changeTypeName(String newName, String oldName) async {
    //XXXXXXXXX SOMETIN WRONG HEA
    //bruh something wrong maybe try to take similar approach as changing type weight
    var url = Uri.parse('$webService/changeTypeName');
    await http.post(
      url,
      body: json.encode(
        {
          'classId': classId,
          'newName': newName,
          'oldName': oldName,
        },
      ),
    );
    setState(() {
      resetFilter = true;
      resetSort = true;
    });
    typesList.length = 0;
    filteredTypeList.length = 0;
    typeNameList.length = 0;
    filteredTypeNameList.length = 0;
    typeBubblList.length = 0;

    var response = await http.get(url);
    var decoded = json.decode(response.body);
    setState(() {
      if (decoded.length != 0) {
        for (var row in decoded) {
          typesList.add([row['typeName'], row['weight']]);
          filteredTypeList.add([row['typeName'], row['weight']]);
        }
        for (var type in typesList) {
          typeNameList.add(type[0]);
          filteredTypeNameList.add(type[0]);
        }
      }
    });
    listOfAssignments.length = 0;
    var url2 = Uri.parse('$webService/fetchAssignmentData');
    await http.post(url2, body: json.encode({'classId': classId}));
    var response2 = await http.get(url2);
    var decoded2 = json.decode(response2.body);
    if (decoded2.length != 0) {
      for (var row in decoded2) {
        DateTime date = DateTime.parse(row['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
        listOfAssignments.add(
          new AssCard(
              row['assignmentId'],
              row['classId'],
              row['type'],
              row['name'],
              row['grade'],
              formattedDate,
              row['comment'],
              deleteAssignment,
              editAssignmentComment,
              colorList[typeNameList.indexOf(row['type'])]),
        );
      }
    }
    setState(() {
      assignmentList = AssList(listOfAssignments);
    });
  }

  void changeTypeWeight() async {
    for (var type in typesList) {
      var url = Uri.parse('$webService/changeTypeWeight');
      await http.post(
        url,
        body: json.encode(
          {
            'classId': classId,
            'typeName': type[0],
            'weight': type[1],
          },
        ),
      );
    }

    var url2 = Uri.parse('$webService/recalcAverage');
    var response2 =
        await http.post(url2, body: json.encode({'classId': classId}));
    var formattedResponse = json.decode(response2.body);
    var newAverage = formattedResponse['newAverage'];
    setState(() {
      currentGrade = double.parse(newAverage);
    });
  }

  void deleteType(String type, int weight) async {
    //RECALC AVERAGE
    String typeNameRecievingWeight;
    int typeWeightRecievingWeight;
    if (typeNameList.indexOf(type) == 0) {
      typeNameRecievingWeight = typeNameList[1];
      typeWeightRecievingWeight = typesList[1][1];
    } else {
      typeNameRecievingWeight = typesList[typeNameList.indexOf(type) - 1][0];
      typeWeightRecievingWeight = typesList[typeNameList.indexOf(type) - 1][1];
    }
    var url = Uri.parse('$webService/deleteType');
    await http.post(
      url,
      body: json.encode(
        {
          'classId': classId,
          'typeName': type,
          'weight': weight,
          'typeNameRecievingWeight': typeNameRecievingWeight,
          'typeWeightRecievingWeight': typeWeightRecievingWeight
        },
      ),
    );
    setState(() {
      resetFilter = true;
      resetSort = true;
    });
    typesList.length = 0;
    filteredTypeList.length = 0;
    typeNameList.length = 0;
    filteredTypeNameList.length = 0;
    typeBubblList.length = 0;

    var response = await http.get(url);
    var decoded = json.decode(response.body);
    setState(() {
      if (decoded.length != 0) {
        for (var row in decoded) {
          typesList.add([row['typeName'], row['weight']]);
          filteredTypeList.add([row['typeName'], row['weight']]);
        }
        for (var type in typesList) {
          typeNameList.add(type[0]);
          filteredTypeNameList.add(type[0]);
        }
      }
    });
    listOfAssignments.length = 0;
    var url2 = Uri.parse('$webService/fetchAssignmentData');
    await http.post(url2, body: json.encode({'classId': classId}));
    var response2 = await http.get(url2);
    var decoded2 = json.decode(response2.body);
    if (decoded2.length != 0) {
      for (var row in decoded2) {
        DateTime date = DateTime.parse(row['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
        listOfAssignments.add(
          new AssCard(
              row['assignmentId'],
              row['classId'],
              row['type'],
              row['name'],
              row['grade'],
              formattedDate,
              row['comment'],
              deleteAssignment,
              editAssignmentComment,
              colorList[typeNameList.indexOf(row['type'])]),
        );
      }
    }
    setState(() {
      assignmentList = AssList(listOfAssignments);
    });
  }

  void filterAssignmentList(List<String> types, String startDate,
      String endDate, int minGrade, int maxGrade) async {
    isLoading = true;
    var url = Uri.parse('$webService/filterAssignmentList');
    await http.post(url,
        body: json.encode({
          'classId': classId,
          'types': types,
          'startDate': startDate,
          'endDate': endDate,
          'minGrade': minGrade,
          'maxGrade': maxGrade
        }));
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    List<AssCard> filteredAssignments = [];
    if (decoded.length != 0) {
      for (var row in decoded) {
        DateTime date = DateTime.parse(row['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date).toString();
        filteredAssignments.add(
          new AssCard(
              row['assignmentId'],
              row['classId'],
              row['type'],
              row['name'],
              row['grade'],
              formattedDate,
              row['comment'],
              deleteAssignment,
              editAssignmentComment,
              colorList[typeNameList.indexOf(row['type'])]),
        );
      }
      setState(() {
        listOfAssignments = filteredAssignments;
        assignmentList = AssList(listOfAssignments);

        sortAssignments(currentSortType);
        isLoading = false;
      });
    } else {
      setState(() {
        listOfAssignments.length = 0;
        assignmentList = AssList(listOfAssignments);

        isLoading = false;
      });
    }
  }

  void deleteAssignment(Widget widget) async {
    int ind = 0;
    int id = 0;
    for (var assignment in listOfAssignments) {
      if (assignment == widget) {
        ind = listOfAssignments.indexOf(assignment);
        id = assignment.assignmentId;
        var url = Uri.parse('$webService/deleteAssignment');
        await http.post(
          url,
          body: json.encode({
            'assignmentId': id,
          }),
        );
        recalcAverage();
        listOfAssignments.remove(assignment);
        assignmentList.listKey.currentState!.removeItem(
          ind,
          (context, animation) => AssDeletionWidget(true),
        );
      }
    }
  }

  void editAssignmentComment(int id, String newComment) async {
    for (var assignment in listOfAssignments) {
      if (assignment.assignmentId == id) {
        var url = Uri.parse('$webService/editAssignmentComment');
        await http.post(
          url,
          body: json.encode({
            'assignmentId': id,
            'comment': newComment,
          }),
        );
      }
    }
  }

  void sortAssignments(int sortType) {
    currentSortType = sortType;
    if (sortType == 1) {
      sortAssignmentListNewToOld();
    } else if (sortType == 2) {
      setState(() {
        setState(() {
          listOfAssignments.sort(
            (a, b) => DateTime.parse(a.date).compareTo(
              DateTime.parse(b.date),
            ),
          );
        });
      });
    } else if (sortType == 3) {
      setState(() {
        listOfAssignments.sort(
          (b, a) => a.grade.compareTo(b.grade),
        );
      });
    } else if (sortType == 4) {
      setState(() {
        listOfAssignments.sort(
          (a, b) => a.grade.compareTo(b.grade),
        );
      });
    } else if (sortType == 5) {
      setState(() {
        listOfAssignments.sort(
          (a, b) => a.name.toLowerCase().compareTo(
                b.name.toLowerCase(),
              ),
        );
      });
    } else if (sortType == 6) {
      setState(() {
        listOfAssignments.sort(
          (b, a) => a.name.toLowerCase().compareTo(
                b.name.toLowerCase(),
              ),
        );
      });
    } else if (sortType == 7) {
      //MAYBE JUST MAYBE DO THE ORDER BY TYPE WEIGHT INSTEAD OF ALPHABETICAL
      setState(() {
        listOfAssignments.sort(
          (a, b) => a.type.toLowerCase().compareTo(
                b.type.toLowerCase(),
              ),
        );
      });
    }
    setState(() {
      assignmentList = AssList(listOfAssignments);
    });
  }

  Future openDialog() {
    dropdownvalue = typeNameList[0];
    var nameController = TextEditingController();
    var gradeController = TextEditingController();
    var dateController = TextEditingController();
    dateController.text = DateFormat('MMM d, yyyy').format(DateTime.now());
    var commentController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Assignment',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 185,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: 150,
                  child: Card(
                    color: Color.fromRGBO(66, 66, 66, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          width: 1.5, color: Color.fromRGBO(158, 158, 158, 1)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Color.fromRGBO(66, 66, 66, 1),
                        value: dropdownvalue,
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
                          dropdownvalue = newValue!;
                          setState(() {});
                        },
                        items: typeNameList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: TextField(
                    cursorColor: Color.fromRGBO(216, 194, 251, 1),
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(255, 255, 255, 1)),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Name',
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
                    controller: nameController,
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: TextField(
                    cursorColor: Color.fromRGBO(216, 194, 251, 1),
                    maxLength: 3,
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(255, 255, 255, 1)),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Grade',
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
                    controller: gradeController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: TextField(
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                      decoration: InputDecoration(
                        isDense: true,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Color.fromRGBO(216, 194, 251, 1),
                        ),
                        hintText: 'Date',
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
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color.fromRGBO(216, 194, 251, 1),
                                  onPrimary: Color.fromRGBO(66, 66, 66, 1),
                                  onSurface: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Color.fromRGBO(216, 194, 251, 1),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('MMM d, yyyy').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                      controller: dateController),
                ),
                SizedBox(
                  height: 35,
                  child: TextField(
                    cursorColor: Color.fromRGBO(216, 194, 251, 1),
                    maxLength: 90,
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(255, 255, 255, 1)),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Comment',
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
                    controller: commentController,
                  ),
                ),
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              addAssignment(
                dropdownvalue,
                nameController.text,
                int.parse(gradeController.text),
                dateController.text,
                commentController.text,
              );
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

  @override
  Widget build(BuildContext context) {
    if (isfirstRound) {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      classId = arguments['classId'];
      className = arguments['className'];
      currentGrade = arguments['currentGrade'].toDouble();
      setState(() {
        userName = arguments['userName'];
      });
      initPage();
      editableTypeList = typesList;
    }

    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(66, 66, 66, 1),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          height: mediaQuery.size.height * 0.13,
          child: CupertinoNavigationBar(
            leading: Align(
              alignment: Alignment(-1.15, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 25,
                color: Color.fromRGBO(216, 194, 251, 1),
                onPressed: () {
                  Navigator.pop(context, currentGrade);
                },
              ),
            ),
            backgroundColor: Color.fromRGBO(66, 66, 66, 1),
            middle: Text(
              userName,
              style: Theme.of(context).textTheme.headline2,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 15),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: mediaQuery.size.width * 0.7,
                            height: mediaQuery.size.height * 0.065,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                className,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                height: 40,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    setState(() {
                                      if (settingsOpen == false) {
                                        settingsOpen = !settingsOpen;
                                      }
                                    });
                                    await Future.delayed(
                                        const Duration(seconds: 1), () {});
                                    setState(() {});
                                  },
                                  child: Image.asset(
                                    settingsOpen
                                        ? 'Assets/images/settingsButtonFilled.png'
                                        : 'Assets/images/settingsButton.png',
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      height: 70,
                      width: mediaQuery.size.width,
                      color: Color.fromRGBO(42, 42, 42, 1),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 24,
                            right:
                                10), //11 should be 15 but needa work out spacing
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Current Grade: ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                                Text(
                                  currentGrade.toString() +
                                      '%', //LIMIT TO ONLY 3 DIGIT NUMBERS
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 33,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 11, bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FilterButton(
                            filterAssignmentList,
                            filteredTypeNameList,
                            typeNameList,
                            filterVisible,
                            changeSortVisibility,
                            resetFilter,
                            changeFilterReset,
                            typeBubblList,
                            colorList,
                          ),
                          SortButton(
                            sortVisible,
                            changeFilterVisibiity,
                            sortAssignments,
                            resetSort,
                            changeSortReset,
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? Expanded(
                            child: ListView(
                            children: [
                              Container(
                                height: mediaQuery.size.height * 0.20,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(216, 194, 251, 1),
                                ),
                              ),
                            ],
                          ))
                        : Expanded(
                            child: assignmentList,
                          ),
                  ],
                ),
              ),
            ),
            Settings(
              className,
              classLevel,
              settingsOpen,
              changeSettingsToClosed,
              typesList,
              addType,
              deleteType,
              changeTypeName,
              editableTypeList,
              changeTypeWeight,
              changeClassLevel,
            ),
          ],
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
      //     //     ElevatedButton(
      //     //       child: Text(
      //     //         'Classes',
      //     //       ),
      //     //       onPressed: () {
      //     //         setState(() {});
      //     //       },
      //     //     ),
      //     //     ElevatedButton(
      //     //       child: Text(
      //     //         'GPA',
      //     //       ),
      //     //       onPressed: () {
      //     //         setState(() {});
      //     //       },
      //     //     ),
      //     //   ],
      //     // ),
      //   ),
      // ),
    );
  }
}
