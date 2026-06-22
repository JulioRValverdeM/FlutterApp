import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/user_stats.dart';

class UserService {

  final Dio dio = Dio();

  Future<UserStats> getStats() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    final response = await dio.get(
      '${ApiConfig.baseUrl}/users/me/stats',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token'
        },
      ),
    );

    return UserStats.fromJson(
      response.data,
    );
  }
}