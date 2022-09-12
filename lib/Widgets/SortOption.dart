import 'package:flutter/material.dart';

class SortOption extends StatefulWidget {
  bool visible;
  bool selected;
  String name;
  int sortType;
  final void Function(int sortType) sortFunction;
  final void Function(int sortTypeIndex) changeSortType;

  SortOption(this.visible, this.selected, this.name, this.sortType,
      this.sortFunction, this.changeSortType);

  @override
  State<SortOption> createState() => _SortOptionState();
}

class _SortOptionState extends State<SortOption> {
  @override
  Widget build(BuildContext context) {
    Duration animationDur = Duration(milliseconds: 300);
    return GestureDetector(
        child: AnimatedContainer(
          width: widget.selected ? double.maxFinite : 0,
          alignment: Alignment.topLeft,
          duration: animationDur,
          color: widget.selected
              ? Color.fromRGBO(142, 116, 244, 1)
              : Color.fromRGBO(
                  66, 66, 66, 1), //null is the white color background thing
          height: widget.visible ? 0 : 34,
          child: Padding(
            padding: EdgeInsets.only(top: 7, left: 20, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Text(
                    widget.name,
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
        onTap: () {
          widget.sortFunction(widget.sortType);
          widget.changeSortType(widget.sortType - 1);
        });
  }
}
