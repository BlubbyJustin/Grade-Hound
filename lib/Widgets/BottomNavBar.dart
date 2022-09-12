import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //FIGURE OUT THE NAVIGATION BAR
            ElevatedButton(
              child: Text(
                'Classes',
              ),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text(
                'GPA',
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
