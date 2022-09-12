import 'package:flutter/material.dart';

class AccountCategory extends StatefulWidget {
  bool isSelected = false;

  @override
  State<AccountCategory> createState() => _AccountCategoryState();
}

class _AccountCategoryState extends State<AccountCategory> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _isSelected = true;
            });
          },
          child: Card(
            child: ListTile(
              title: Text('1'),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isSelected = false;
            });
          },
          child: Card(
            child: ListTile(title: Text('2')),
          ),
        )
      ],
    );
  }
}
