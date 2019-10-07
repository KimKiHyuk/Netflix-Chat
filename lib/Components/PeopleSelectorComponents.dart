import 'package:flutter/material.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class PeopleSelectorComponents extends StatefulWidget {
  @override
  State createState() => PeopleSelector();
}

class PeopleSelector extends State<PeopleSelectorComponents> {
  List<String> _peopleList;
  String _dropDownValue;

  PeopleSelector() {
    _peopleList = ['2명', '3명', '4명'];
    _dropDownValue = _peopleList[2];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('본인을 포함한 파티원 수를 선택해주세요', style: TextStyle(color: Colors.white),),
        Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black12,
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: Consumer<UserStore>(
                builder: (context, userStore, child) => Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.grey),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.people),
                    style:  TextStyle(color: Colors.white, fontSize: 18),
                    value: _dropDownValue,
                    items: _peopleList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) async {
                      setState(() {
                        userStore.SetPartyPeople(
                            int.parse(newValue.substring(0, 1)));
                        _dropDownValue = newValue;
                        print('value is changed ' + _dropDownValue);
                      });
                    },
                  ),
                ))),
      ],
    );
  }
}
