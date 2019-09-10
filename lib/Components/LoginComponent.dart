import 'package:flutter/material.dart';
import 'package:netflix_together/validator/validator.dart';

class LoginComponent extends StatelessWidget {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // TODO : Dependency injecton

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 6,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0, top: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.email), labelText: 'Email'),
                  validator: new Validator()
                      .stringValadator, // TODO : dependency injection
                ),
                TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.security), labelText: 'Password'),
                    validator: (String value) {
                      return value.isEmpty ? 'Please input data' : null;
                    }),
                Text('Forget password?'),
                Container(
                    margin: EdgeInsets.only(top: 15.0),
                    alignment: Alignment(0.0, 0.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: SizedBox(
                        width: size * 0.5,
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {},
                    ))
              ]),
        ),
      ),
    );
  }
}
