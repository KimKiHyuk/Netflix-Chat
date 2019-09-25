class Validator {

  void Initalize() {
    print('Validator initalize done');
  }

  Function(String) stringValadator = (String value) {
    return value.isEmpty ? '빈칸을 채워주세요' : null;
  };


}
