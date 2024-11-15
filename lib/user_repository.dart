import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return const UserRepository();
});

class UserRepository {
  const UserRepository();

  static const sourceLabel = 'Mock REST · JSON';

  Future<User> getUser({bool shouldFail = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));

    if (shouldFail) {
      throw const UserRepositoryException(
        '503 · Sample API is unavailable',
      );
    }

    const serverResponse = '''
{
  "name": "이지원",
  "age": 20,
  "headline": "Flutter architecture learner",
  "learningTrack": "Riverpod · MVVM · immutable state"
}
''';

    return User.fromJson(jsonDecode(serverResponse) as Map<String, dynamic>);
  }
}

class UserRepositoryException implements Exception {
  const UserRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
