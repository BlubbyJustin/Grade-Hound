import 'package:flutter/material.dart';

class AssDeletionWidget extends StatefulWidget {
  bool visible;

  AssDeletionWidget(this.visible);

  @override
  State<AssDeletionWidget> createState() => _AssDeletionWidgetState();
}

class _AssDeletionWidgetState extends State<AssDeletionWidget> {
  @override
  //idk how to do this animation fam
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: widget.visible ? 1 : 0,
      child: Container(
        height: 210,
        width: double.infinity,
        child: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: Color.fromRGBO(255, 204, 203, 1),
            elevation: 5),
      ),
    );
  }
}
