import 'package:first_app/Widgets/TypeBubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TypeBubble.dart';
import 'FilterDateInput.dart';
import 'FilterGradeInput.dart';
import '../Pages/ClassPage.dart';

class FilterButton extends StatefulWidget {
  final Function(List<String> types, String startDate, String endDate,
      int minGrade, int maxGrade) FilterListCallback;

  List<String> filteredTypeList;
  List<String> typeList;

  bool visible;
  final void Function() changeSortVisibility;

  bool reset;
  final void Function() changeReset;

  List<TypeBubble> typeBubbleList;

  List<Color> colorList;

  FilterButton(
    this.FilterListCallback,
    this.filteredTypeList,
    this.typeList,
    this.visible,
    this.changeSortVisibility,
    this.reset,
    this.changeReset,
    this.typeBubbleList,
    this.colorList,
  );
  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool selected = true;

  bool somethingChanged = false;

  String startDate = '2015-01-01';
  String endDate = '2029-01-01';
  int minGrade = 0;
  int maxGrade = 999;

  String proxyStartDate = '2015-01-01';
  String proxyEndDate = '2029-01-01';
  int proxyMinGrade = 0;
  int proxyMaxGrade = 999;

  void recordChange() {
    setState(() {
      somethingChanged = true;
    });
  }

  void setDates(bool isStart, String date) {
    if (isStart == true) {
      proxyStartDate = date;
    } else {
      proxyEndDate = date;
    }
  }

  void setGrades(bool isMin, int number) {
    if (isMin == true) {
      proxyMinGrade = number;
    } else {
      proxyMaxGrade = number;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reset) {
      setDates(true, '2015-01-01');
      setDates(false, '2029-01-01');
      setGrades(true, 0);
      setGrades(false, 999);
      widget.changeReset();
    }
    var mediaQuery = MediaQuery.of(context);
    if (widget.typeBubbleList.length == 0) {
      for (var type in widget.typeList) {
        bool _ = true;
        widget.typeBubbleList.add(
          TypeBubble(selected, type, _, recordChange,
              widget.colorList[widget.typeList.indexOf(type)]),
        );
      }
    } else if (widget.typeBubbleList.length != 0 && somethingChanged == false) {
      for (int i = 0; i < widget.typeBubbleList.length; i++) {
        String theType = widget.typeBubbleList[i].type;
        bool _ = false;
        for (var type in widget.filteredTypeList) {
          if (theType == type) {
            _ = true;
            break;
          }
        }
        widget.typeBubbleList.removeAt(i);
        if (widget.typeList.indexOf(theType) != -1) {
          widget.typeBubbleList.insert(
            i,
            TypeBubble(selected, theType, _, recordChange,
                widget.colorList[widget.typeList.indexOf(theType)]),
          );
        }
      }
    }
    Duration animationDur = Duration(milliseconds: 300);
    return GestureDetector(
      child: AnimatedContainer(
        duration: animationDur,
        width: !widget.visible
            ? 0
            : selected
                ? 115
                : mediaQuery.size.width - 40,
        height: selected ? 42 : 340,
        child: Card(
          color: Color.fromRGBO(66, 66, 66, 1),
          shape: RoundedRectangleBorder(
            borderRadius: selected
                ? BorderRadius.circular(20)
                : BorderRadius.circular(10),
            side: BorderSide(
              width: 2,
              color: selected
                  ? Color.fromRGBO(216, 194, 251, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: AnimatedContainer(
                  duration: animationDur,
                  margin: selected
                      ? EdgeInsets.only(top: 5, left: 15)
                      : EdgeInsets.only(top: 13, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        fit: FlexFit.loose,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 7,
                              child: Text(
                                'Filter',
                                maxLines: 1,
                                style: selected
                                    ? TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Color.fromRGBO(216, 194, 251, 1),
                                      )
                                    : TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: widget.visible
                                  ? selected
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Image.asset(
                                            'Assets/images/purpleFunnel.png',
                                            scale: 2,
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: GestureDetector(
                          child: AnimatedContainer(
                            width: selected ? 0 : 25,
                            margin: EdgeInsets.only(right: 15),
                            duration: animationDur,
                            child: Image.asset(
                              'Assets/images/xOutButton.png',
                              scale: 2,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selected = true;
                              widget.changeSortVisibility();

                              proxyStartDate = startDate;
                              proxyEndDate = endDate;
                              proxyMinGrade = minGrade;
                              proxyMaxGrade = maxGrade;
                              somethingChanged = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: selected
                    ? Duration(milliseconds: 300) //1?
                    : Duration(milliseconds: 300),
                height: selected ? 0 : 38,
                width: selected ? 80 : double.maxFinite,
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 13, 20, 0),
                  child: Text(
                    'Type',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: animationDur,
                height: selected ? 0 : 87,
                //color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                  child: ListView(
                    children: [
                      Wrap(
                        children: [
                          for (var typeBubble in widget.typeBubbleList)
                            typeBubble
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                //color: Colors.red,
                duration: selected
                    ? Duration(milliseconds: 300)
                    : Duration(milliseconds: 300),
                height: selected ? 0 : 30,
                width: selected ? 80 : double.maxFinite,
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                //color: Colors.green,
                duration: animationDur,
                height: selected ? 0 : 45, //45
                //color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 3, 15, 0),
                  child: Row(
                    children: [
                      FilterDateInput(selected, setDates, true, proxyStartDate,
                          recordChange),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          alignment: Alignment.topCenter,
                          child: Text(
                            'to',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                      FilterDateInput(
                          selected, setDates, false, proxyEndDate, recordChange)
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                //color: Colors.red,
                duration: selected
                    ? Duration(milliseconds: 300) //1?
                    : Duration(milliseconds: 300),
                height: selected ? 0 : 30,
                width: selected ? 80 : double.maxFinite,
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'Grade',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                //color: Colors.green,
                duration: animationDur,
                height: selected ? 0 : 45, //45
                //color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 3, 19, 0),
                  child: AnimatedContainer(
                    duration: animationDur,
                    width: selected ? 0 : double.maxFinite,
                    child: Row(
                      children: [
                        FilterGradeInput(selected, proxyMinGrade, true,
                            setGrades, recordChange),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            alignment: Alignment.topCenter,
                            child: Text(
                              ' ≤  x  ≤ ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                        FilterGradeInput(selected, proxyMaxGrade, false,
                            setGrades, recordChange),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: AnimatedContainer(
                              duration: animationDur,
                              width: selected ? 0 : 48,
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: somethingChanged
                                      ? Color.fromRGBO(216, 194, 251, 1)
                                      : Color.fromRGBO(120, 120, 120, 1),
                                ),
                              ),
                            ),
                            onTap: somethingChanged
                                ? () {
                                    setState(() {
                                      selected = true;
                                      widget.changeSortVisibility();
                                      widget.filteredTypeList.length = 0;
                                      for (var typeBubble
                                          in widget.typeBubbleList) {
                                        if (typeBubble.selected == true) {
                                          widget.filteredTypeList
                                              .add(typeBubble.type);
                                        }
                                      }
                                      startDate = proxyStartDate;
                                      endDate = proxyEndDate;
                                      minGrade = proxyMinGrade;
                                      maxGrade = proxyMaxGrade;
                                    });
                                    widget.FilterListCallback(
                                        widget.filteredTypeList,
                                        startDate,
                                        endDate,
                                        minGrade,
                                        maxGrade);
                                    somethingChanged = false;
                                  }
                                : () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        if (selected) {
          setState(() {
            selected = !selected;
            widget.changeSortVisibility();
          });
          await Future.delayed(const Duration(seconds: 1), () {});
          setState(() {});
        }
      },
    );
  }
}
