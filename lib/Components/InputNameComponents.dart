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
              Text('채팅에 참여할 이름을 입력해주세요.'),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '이름을 입력해주세요'),
                onChanged: (name) => {
                  userStore.setName(name),
                },
              ),
            ],
          ),
        ));
  }
}
