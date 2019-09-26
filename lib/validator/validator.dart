class Validator {
  void Initalize() {
    print('Validator initalize done');
  }

  Function(String) stringValadator = (String value) {
    return value.isEmpty ? '빈칸을 채워주세요' : null;
  };

  bool stringSatisfiedWithName(String value) {
    // value has aggresive words? like f***,s**, 시*, 병* ...
    // TODO : 욕설분류기 서버 연결
    print('validator : ' + value);
    if (value != 'default' && value != null && value != '') {
      return true;
    }
    return false;
  }
}
