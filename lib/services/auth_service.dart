import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class AuthService {

  final Dio dio = Dio();

  Future<bool> login(
      String email,
      String password
      ) async {

    try {

      final response = await dio.post(
        '${ApiConfig.baseUrl}/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token =
      response.data['token'];

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        'token',
        token,
      );

      return true;

    } catch (e) {

      print(e);

      return false;

    }
  }
}