class Validator {
  void Initalize() {
    print('Validator initalize done');
  }

  bool stringNullOrEmptyValadator(String value) {
    print('null or empty?  :: ' + value);
    return value.isNotEmpty;
  }

  bool stringSatisfiedWithName(String value) {
    // value has aggresive words? like f***,s**, 시*, 병* ...
    // TODO : 욕설분류기 서버 연결
    return (value != null && value != '' && value.isNotEmpty);
  }
}
