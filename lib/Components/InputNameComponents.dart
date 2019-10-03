import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:netflix_together/validator/validator.dart';
import 'package:provider/provider.dart';

class InputNameComponents extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final injector = Injector.getInjector().get<Validator>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
        width: size.width * 0.6,
        child: Consumer<UserStore>(
          builder: (context, userStore, child) => Column(
            children: <Widget>[
              Text(
                '채팅에 참여할 이름을 입력해주세요.',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력해주세요',
                  hintStyle: TextStyle(color: Colors.white10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                onChanged: (name) => {
                  userStore.setName(name),
                },
              ),
            ],
          ),
        ));
  }
}
