import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDateInput extends StatefulWidget {
  bool visible;
  final Function(bool isStart, String date) setDate;
  bool isStart;
  String initialDate;
  final Function() changeIndicator;

  FilterDateInput(this.visible, this.setDate, this.isStart, this.initialDate,
      this.changeIndicator);

  @override
  State<FilterDateInput> createState() => _FilterDateInputState();
}

class _FilterDateInputState extends State<FilterDateInput> {
  @override
  Widget build(BuildContext context) {
    widget.setDate(widget.isStart, widget.initialDate);
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
          child: AnimatedContainer(
            duration: animationDur,
            height: widget.visible ? 0 : 45,
            width: widget.visible ? 0 : 127,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: animationDur,
                  height: widget.visible ? 0 : 45,
                  width: widget.visible ? 0 : 90,
                  alignment: Alignment.topLeft,
                  margin: widget.visible
                      ? EdgeInsets.zero
                      : EdgeInsets.only(left: 10, top: 7),
                  child: Text(
                    DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(widget.initialDate)),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: 2),
                  width: widget.visible ? 0 : 10,
                  child: Icon(
                    Icons.calendar_today,
                    size: widget.visible ? 0 : 20,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(widget.initialDate),
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
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            widget.initialDate = formattedDate;
            widget.setDate(widget.isStart, formattedDate);
            widget.changeIndicator();
          });
        }
      },
    );
  }
}
