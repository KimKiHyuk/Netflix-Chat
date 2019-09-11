import 'package:flutter/material.dart';

class PeopleSelectorComponents extends StatefulWidget {
  @override
  State createState() => PeopleSelector();
}


class PeopleSelector extends State<PeopleSelectorComponents>
{
  List<String> _peopleList = ['2명', '3명', '4명'];
  String dropDownValue = '4명';

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('파티원 수 (본인 포함) :   ',),
          DropdownButton<String>(
            icon: Icon(Icons.people),
            value: dropDownValue,
            items: _peopleList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) async {
              setState(() {
                dropDownValue = newValue;
                print('value is changed ' + dropDownValue);
              });
            },
          )
        ],
    );
  }
}