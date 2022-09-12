import 'package:flutter/material.dart';
import 'package:first_app/Widgets/AssCard.dart';

class AssList extends StatefulWidget {
  List<AssCard> listOfAssign = [];
  final listKey = GlobalKey<AnimatedListState>();

  AssList(this.listOfAssign);

  @override
  State<AssList> createState() => _AssListState();
}

class _AssListState extends State<AssList> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return widget.listOfAssign.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return ListView(
                children: [
                  Container(
                    height: mediaQuery.size.height * 0.25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "No Assignments",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              );
            },
          )
        : AnimatedList(
            key: widget.listKey,
            initialItemCount: widget.listOfAssign.length,
            itemBuilder: (context, index, aimation) {
              if (index == widget.listOfAssign.length - 1) {
                return Column(
                  children: [
                    widget.listOfAssign[index],
                    SizedBox(
                      height: mediaQuery.viewInsets.bottom,
                    ),
                    SizedBox(
                      height: 110,
                    )
                  ],
                );
              } else {
                return widget.listOfAssign[index];
              }
            },
          );
  }
}
