import 'package:flutter/material.dart';

class nameTf extends StatefulWidget {
  String label;
  String hintText;
  TextEditingController controller;

  nameTf(this.label, this.hintText, this.controller);

  @override
  State<nameTf> createState() => _nameTfState();
}

class _nameTfState extends State<nameTf> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 52,
          child: Card(
            elevation: 0,
            color: Color.fromRGBO(66, 66, 66, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: Color.fromRGBO(255, 255, 255, 1),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              //scrollPhysics: NeverScrollableScrollPhysics(),
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              cursorColor: Color.fromRGBO(255, 255, 255, 1),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromRGBO(158, 158, 158, 1),
                ),
                contentPadding: EdgeInsets.only(left: 14, right: 14, bottom: 6),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
