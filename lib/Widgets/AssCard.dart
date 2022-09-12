//import 'dart:html';
//MAYBE TRY PASSIGN A FUNCTION TO CLASSPAGE???? IDEK ///////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AssCard extends StatefulWidget {
  int assignmentId;
  int classId;
  String type;
  String name;
  int grade;
  String date;
  String comment;
  bool selected = true;
  final void Function(Widget widget) deleteThisAssignment;
  final void Function(int id, String comment) editComment;
  Color typeColor;

  AssCard(
    this.assignmentId,
    this.classId,
    this.type,
    this.name,
    this.grade,
    this.date,
    this.comment,
    this.deleteThisAssignment,
    this.editComment,
    this.typeColor,
  );

  @override
  State<AssCard> createState() => _AssCardState();
}

class _AssCardState extends State<AssCard> {
  double cardHeight = 90;
  bool commentEdited = false;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController(text: widget.comment);
    commentController.selection =
        TextSelection.collapsed(offset: commentController.text.length);

    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: widget.selected ? cardHeight : cardHeight + 120,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Color.fromRGBO(42, 42, 42, 1),
        elevation: 5,
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              width: 25,
              height: widget.selected ? cardHeight : cardHeight + 200,
              decoration: BoxDecoration(
                color: widget.typeColor,
                border: Border.all(
                  color: widget.typeColor,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.type,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(66, 66, 66, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 9, right: 0),
                  width: mediaQuery.size.width * 0.76,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.35,
                        alignment: Alignment.topLeft,
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM d, yyyy')
                                    .format(DateTime.parse(widget.date))
                                    .toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(widget.name,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.grade.toString() + '%',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  widget.selected = !widget.selected;
                                  if (commentEdited == true) {
                                    commentEdited = !commentEdited;
                                  }
                                });
                              },
                              child: Image.asset(
                                widget.selected
                                    ? 'Assets/images/commentButton.png'
                                    : 'Assets/images/commentButtonFilled.png',
                                height: 30,
                                scale: 2,
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  color: Color.fromRGBO(66, 66, 66, 1),
                  duration: Duration(milliseconds: 300),
                  height: widget.selected ? 0 : 90,
                  width: mediaQuery.size.width * 0.725,
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15, right: 12),
                  child: widget.selected
                      ? Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                          child: Text(
                            widget.comment,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color.fromRGBO(66, 66, 66, 1),
                            ),
                          ),
                        )
                      : TextField(
                          onChanged: (_) {
                            if (commentEdited == false) {
                              setState(() {
                                commentEdited = !commentEdited;
                              });
                            }
                          },
                          controller: commentController,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          maxLength: 90,
                          decoration: InputDecoration(
                            counterText: '',
                            fillColor: Color.fromRGBO(66, 66, 66, 1),
                            filled: true,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10, top: 9),
                          ),
                        ),
                ),
                AnimatedContainer(
                  margin: EdgeInsets.only(left: 15, right: 12),
                  duration: Duration(milliseconds: 300),
                  height: widget.selected ? 0 : 39,
                  width: mediaQuery.size.width * 0.725,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            'Delete Assignment',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color.fromRGBO(252, 48, 48, 1),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              widget.deleteThisAssignment(widget);
                            });
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: commentEdited
                                  ? Color.fromRGBO(216, 194, 251, 1)
                                  : Color.fromRGBO(120, 120, 120, 1),
                            ),
                          ),
                          onTap: () {
                            if (commentEdited == true) {
                              setState(() {
                                widget.selected = true;
                                widget.comment = commentController.text;
                                widget.editComment(
                                  widget.assignmentId,
                                  commentController.text,
                                );
                                commentEdited = !commentEdited;
                              });
                            }
                          },
                        ),
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
