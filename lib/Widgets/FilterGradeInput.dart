import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FilterGradeInput extends StatefulWidget {
  bool visible;
  int number;
  bool minOrMax;
  final void Function(bool isMin, int number) setGrades;
  final Function() changeIndicator;

  FilterGradeInput(this.visible, this.number, this.minOrMax, this.setGrades,
      this.changeIndicator);
  @override
  State<FilterGradeInput> createState() => _FilterGradeInputState();
}

class _FilterGradeInputState extends State<FilterGradeInput> {
  Future openDialog() {
    var numberController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          widget.minOrMax ? 'Input Minimum Grade' : 'Input Maximum Grade',
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        content: Container(
          height: 60,
          child: Column(
            children: [
              TextField(
                maxLength: 3,
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: widget.minOrMax ? 'minimum grade' : 'maximum grade',
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
                controller: numberController..text = widget.number.toString(),
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
              setState(() {
                widget.number = int.parse(numberController.text);
                widget.setGrades(widget.minOrMax, widget.number);
                widget.changeIndicator();
              });
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

  @override
  Widget build(BuildContext context) {
    widget.setGrades(widget.minOrMax, widget.number);
    Duration animationDur = Duration(milliseconds: 300);
    return GestureDetector(
      child: AnimatedContainer(
        duration: animationDur,
        alignment: Alignment.topLeft,
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
          child: Row(
            children: [
              AnimatedContainer(
                duration: animationDur,
                width: widget.visible ? 0 : 45,
                alignment: Alignment.topLeft,
                margin: widget.visible
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: 10, top: 7),
                child: Text(
                  widget.number.toString(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => openDialog(),
    );
  }
}
