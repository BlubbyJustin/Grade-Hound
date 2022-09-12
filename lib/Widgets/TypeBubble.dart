import 'package:flutter/material.dart';

class TypeBubble extends StatefulWidget {
  bool visible;
  String type;
  bool selected;
  Color typeColor;
  final Function() changeIndicator;

  TypeBubble(
    this.visible,
    this.type,
    this.selected,
    this.changeIndicator,
    this.typeColor,
  );

  @override
  State<TypeBubble> createState() => _TypeBubbleState();
}

class _TypeBubbleState extends State<TypeBubble> {
  void changeSelectToTrue() {
    widget.selected = true;
    print('done');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: widget.type.length.toDouble() < 7
            ? 90
            : widget.type.length.toDouble() * 15,
        height: widget.visible ? 0 : 42,
        child: Card(
          color: widget.selected
              ? widget.typeColor
              : Color.fromRGBO(66, 66, 66, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 2,
              color: widget.selected
                  ? widget.typeColor
                  : Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          elevation: 0.0,
          child: Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.type,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: widget.selected
                      ? Color.fromRGBO(66, 66, 66, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
        widget.changeIndicator();
      },
    );
  }
}
