import 'package:flutter/material.dart';
import 'package:first_app/Widgets/ClassCard.dart';

class ClassList extends StatelessWidget {
  List<ClassCard> listOfClasses = [];

  ClassList(this.listOfClasses);

  //MAKE A METHOD TO GRAB SHIT FROM FIREBASE AND ADD IT TO THAT LIST

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return listOfClasses.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Container(
                  height: mediaQuery.size.height * 0.3,
                ),
                Text(
                  "No classes added yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: listOfClasses.length,
            itemBuilder: (context, index) {
              if (index == listOfClasses.length - 1) {
                return Column(
                  children: [
                    listOfClasses[index],
                    SizedBox(
                      height: mediaQuery.viewInsets.bottom,
                    ),
                    SizedBox(
                      height: 110,
                    )
                  ],
                );
              } else {
                return listOfClasses[index];
              }
            },
          );
  }
}
