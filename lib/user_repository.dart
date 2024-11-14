import 'dart:convert';
import 'package:flutter_riverpod_mvvm/user.dart';

class UserRepository {
  // 서버와 통신할 때에는 항상 비동기!
  Future<User> getUser() async {
    // 서버에서 데이터를 받아오는 데 시간이 걸리므로, 기다렸다가 다음 줄을 실행
    // 여기서는 서버에서 응답받는 시간을 1초로 가정해 Future.delayed를 사용합니다.
    await Future.delayed(const Duration(seconds: 1));

    // 서버에서 받은 데이터라고 가정한 JSON 문자열
    String serverResponse = """
{
	"name": "이지원",
	"age": 20
}
""";

    // 서버에서 받은 JSON 형식의 문자열 데이터를 Map으로 변환
    Map<String, dynamic> map = jsonDecode(serverResponse);

    // Map으로 변환한 데이터를 User 객체로 변환
    User user = User.fromJson(map);

    // 변환된 User 객체를 반환합니다
    return user;
  }
}
