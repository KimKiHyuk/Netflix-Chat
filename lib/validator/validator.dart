class Validator {

  void Initalize() {
    print('Validator initalize done');
  }

  Function(String) stringValadator = (String value) {
    return value.isEmpty ? 'Please input data' : null;
  };


}
