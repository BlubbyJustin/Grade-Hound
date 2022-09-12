import 'package:flutter/material.dart';

class Animate extends StatefulWidget {
  @override
  _AnimateState createState() => _AnimateState();
}

class _AnimateState extends State<Animate> {
  var height = 200.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          color: Colors.amber,
          duration: new Duration(milliseconds: 500),
          child: Card(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (height == 200.0) {
              height = 400.0;
            } else {
              height = 200.0;
            }
          });
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}
