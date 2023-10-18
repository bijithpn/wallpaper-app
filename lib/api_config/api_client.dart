import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.options.headers["Authorization"] = dotenv.env['API_KEY'];
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          // Handle error here
          print('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> getData(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> postData(
    String url, {
    Object? data,
  }) async {
    try {
      Response response = await _dio.get(url, data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
