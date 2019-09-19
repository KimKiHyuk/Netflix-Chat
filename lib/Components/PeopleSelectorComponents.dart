import 'package:flutter/material.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class PeopleSelectorComponents extends StatefulWidget {
  @override
  State createState() => PeopleSelector();
}

class PeopleSelector extends State<PeopleSelectorComponents> {
  static String _defaultSelectedFlag = '선택안함';
  List<String> _peopleList = [_defaultSelectedFlag, '2', '3', '4']; // // rubbish coder is here ^.^; enum please..
  String _dropDownValue = _defaultSelectedFlag;

  //          Consumer<LoginStore>(
  //              builder: (context, loginStore, child) =>
  //              child:
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '파티원 수 (본인 포함) :   ',
        ),
        Container(
            child: Consumer<UserStore>(
                builder: (context, userStore, child) => DropdownButton<String>(
                      icon: Icon(Icons.arrow_downward),
                      style: TextStyle(color: Colors.deepOrange, fontSize: 18),
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
                          newValue == _defaultSelectedFlag ? userStore.SetPartyPeople(int.parse('-1')) : userStore.SetPartyPeople(int.parse(newValue));
                          _dropDownValue = newValue;
                          print('value is changed ' + _dropDownValue);
                        });
                      },
                    ))),
        Text('명으로 넷플릭스 즐기기'),
      ],
    ));
  }
}
