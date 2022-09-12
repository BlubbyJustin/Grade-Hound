import 'package:flutter/material.dart';

class TypeSetting extends StatefulWidget {
  String type;
  int weight;
  void Function(String type, int weight) deleteType;
  void Function(String type, String oldName) changeType;
  void Function(String type, int weight) editTypesList;
  void Function() errorCheckWeights;
  bool weightError;

  TypeSetting(
    this.type,
    this.weight,
    this.deleteType,
    this.changeType,
    this.editTypesList,
    this.errorCheckWeights,
    this.weightError,
  );

  @override
  State<TypeSetting> createState() => _TypeSettingState();
}

class _TypeSettingState extends State<TypeSetting> {
  Future openEditNameDialog() {
    var typeNameController = TextEditingController();
    typeNameController.text = widget.type;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Edit Type Name',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 80,
          child: Column(
            children: [
              TextField(
                maxLength: 30,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Type Name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(216, 194, 251, 1),
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),
                ),
                controller: typeNameController,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.changeType(typeNameController.text, widget.type);
              Navigator.pop(context);
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openEditWeightDialog() {
    var weightController = TextEditingController();
    weightController.text = widget.weight.toString();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Edit Type Weight',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 80,
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                cursorColor: Color.fromRGBO(216, 194, 251, 1),
                decoration: InputDecoration(
                  hintText: 'Type Weight',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(216, 194, 251, 1),
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),
                ),
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.editTypesList(
                widget.type,
                int.parse(weightController.text),
              );
              widget.errorCheckWeights();
              Navigator.pop(context);
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openWeightErrorDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Weight Sum Error',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 80,
          child: Text(
            'Please adjust type weights so that they sum to 100 before performing this action.',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(
                color: Color.fromRGBO(216, 194, 251, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future openDeleteWarningDialog() {
    String truncatedType = (widget.type.length <= 10)
        ? widget.type
        : '${widget.type.substring(0, 10)}...';
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(66, 66, 66, 1),
        title: Text(
          'Delete Assignment Type',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        content: Container(
          height: 110,
          child: Text(
            "Are you sure you want to delete the assignment type '" +
                truncatedType +
                "'? Deleting an assignment type will also permanently delete all of its assignments.",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 17, bottom: 6),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(216, 194, 251, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.deleteType(widget.type, widget.weight);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Color.fromRGBO(66, 66, 66, 1)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17, bottom: 6),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(216, 194, 251, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color.fromRGBO(66, 66, 66, 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 49),
          child: GestureDetector(
            onTap: openEditNameDialog,
            child: Container(
              height: 28,
              width: 90,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.5, right: 5, top: 3.75),
                child: Text(
                  (widget.type.length <= 8)
                      ? widget.type
                      : '${widget.type.substring(0, 8)}...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: openEditWeightDialog,
          child: Container(
            height: 28,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.weightError
                    ? Colors.red
                    : Color.fromRGBO(255, 255, 255, 1),
                width: widget.weightError ? 3 : 1.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.5, right: 5, top: 3.75),
              child: Text(
                widget.weight.toString(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: 25,
          child: Text(
            '%',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              alignment: Alignment.centerRight,
              height: 35,
              child: FloatingActionButton(
                onPressed: () {
                  if (widget.weightError) {
                    openWeightErrorDialog();
                  } else {
                    openDeleteWarningDialog();
                  }
                },
                child: Image.asset(
                  'Assets/images/trashButton.png',
                  scale: 2.4,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
