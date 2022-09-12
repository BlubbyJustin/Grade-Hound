import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'typeBubble.dart';
import 'FilterDateInput.dart';
import 'FilterGradeInput.dart';
import '../Pages/ClassPage.dart';
import 'SortOption.dart';
import 'testWidget.dart';

class SortButton extends StatefulWidget {
  bool visible;
  final void Function() changeFilterVisibility;
  final void Function(int sortType) sortFunction;
  bool reset;
  final void Function() changeReset;

  SortButton(this.visible, this.changeFilterVisibility, this.sortFunction,
      this.reset, this.changeReset);

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool selected = true;

  List sortOptionList = [
    ['Date (New to Old)', true],
    ['Date (Old to New)', false],
    ['Grade (High to Low)', false],
    ['Grade (Low to High)', false],
    ['Name (A to Z)', false],
    ['Name (Z to A)', false],
    ['Type', false],
  ];

  void changeSortType(int sortTypeIndex) {
    for (var sortOption in sortOptionList) {
      if (sortOption[1] == true) {
        setState(() {
          sortOption[1] = false;
        });
      }
    }
    setState(() {
      sortOptionList[sortTypeIndex][1] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reset) {
      changeSortType(0);
      print('k');
      widget.changeReset();
    }
    var mediaQuery = MediaQuery.of(context);
    Duration animationDur = Duration(milliseconds: 300);
    return GestureDetector(
      child: AnimatedContainer(
        duration: animationDur,
        width: !widget.visible
            ? 0
            : selected
                ? 108
                : mediaQuery.size.width - 40,
        height: selected ? 42 : 315,
        child: Card(
          color: Color.fromRGBO(66, 66, 66, 1),
          shape: RoundedRectangleBorder(
            borderRadius: selected
                ? BorderRadius.circular(20)
                : BorderRadius.circular(10),
            side: BorderSide(
              width: 2,
              color: selected
                  ? Color.fromRGBO(216, 194, 251, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: AnimatedContainer(
                  duration: animationDur,
                  margin: selected
                      ? EdgeInsets.only(top: 5, left: 15)
                      : EdgeInsets.only(top: 13, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: Text(
                                selected ? 'Sort' : 'Sort by:',
                                maxLines: 1,
                                style: selected
                                    ? TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Color.fromRGBO(216, 194, 251, 1),
                                      )
                                    : TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: widget.visible
                                  ? selected
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Image.asset(
                                            'Assets/images/purpleSort.png',
                                            scale: 2,
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: GestureDetector(
                          child: AnimatedContainer(
                            width: selected ? 0 : 25,
                            margin: EdgeInsets.only(right: 15),
                            duration: animationDur,
                            child: Image.asset(
                              'Assets/images/xOutButton.png',
                              scale: 2,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selected = true;
                              widget.changeFilterVisibility();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                //FIGURE OUT HOW TO DO THE HIGHLIGHT GREY OUT SHIT, SORTING ALREADY WORKS
                duration: animationDur,
                height: selected ? 0 : 260,
                child: Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return SortOption(
                          selected,
                          sortOptionList[index][1],
                          sortOptionList[index][0],
                          index + 1,
                          widget.sortFunction,
                          changeSortType);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (selected) {
          setState(() {
            selected = !selected;
            widget.changeFilterVisibility();
          });
        }
      },
    );
  }
}


// SortOption(selected, true, 'Date (New to Old)', 1,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Date (Old to New)', 2,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Grade (High to Low)', 3,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Grade (Low to High)', 4,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Name (A to Z)', 5,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Name (Z to A)', 6,
                    //     widget.sortFunction),
                    // SortOption(selected, false, 'Type', 7, widget.sortFunction),
                    // AccountCategory()