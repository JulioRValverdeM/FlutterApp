import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/product.dart';

class ProductService {

  final Dio dio = Dio();

  Future<List<Product>> getProducts() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    final response = await dio.get(
      '${ApiConfig.baseUrl}/products',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return (response.data as List)
        .map(
          (json) => Product.fromJson(json),
        )
        .toList();
  }
}