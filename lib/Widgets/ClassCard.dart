import 'package:first_app/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import '../Pages/ClassPage.dart';

class ClassCard extends StatefulWidget {
  int classId;
  String userId;
  String className;
  int targetGrade;
  double currentGrade;
  Function(int classId) deleteThisClass;
  bool aboveTarget;
  String userName;

  ClassCard(this.classId, this.userId, this.className, this.targetGrade,
      this.currentGrade, this.deleteThisClass, this.aboveTarget, this.userName);

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  Future<void> switchPage(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      ClassPage.pageRoute,
      arguments: {
        'classId': widget.classId,
        'className': widget.className,
        'currentGrade': widget.currentGrade,
        'userName': widget.userName,
      },
    );
    if (result.runtimeType == String) {
      widget.deleteThisClass(widget.classId);
    } else {
      setState(() {
        widget.currentGrade = double.parse(result.toString());
        if (widget.currentGrade.round() >= widget.targetGrade) {
          widget.aboveTarget = true;
        } else {
          widget.aboveTarget = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double proxyGrade = widget.currentGrade;
    int roundedGrade = proxyGrade.round();
    return GestureDetector(
      child: Card(
        color: Color.fromRGBO(42, 42, 42, 1),
        elevation: 5,
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 10, 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 201,
                      child: Text(
                        widget.className,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        //CHANGE OVERFLOW TO BY CHARACTER NOT BY WORDS
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Target Grade: ${widget.targetGrade}% ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Grade:",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: widget.aboveTarget
                            ? Image.asset(
                                'Assets/images/smileyFace.png',
                                scale: 2,
                              )
                            : Image.asset(
                                'Assets/images/frownyFace.png',
                                scale: 2,
                              ),
                      ),
                      Text(
                        roundedGrade.toString() + "%",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          fontSize: 34,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () => switchPage(context),
    );
  }
}
