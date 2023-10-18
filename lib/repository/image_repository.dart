import 'package:dio/dio.dart';
import 'package:flutter_wallpaper_app/api_config/api_client.dart';
import 'package:flutter_wallpaper_app/api_config/api_config.dart';

class ImageRepository {
  fetchData() async {
    ApiClient apiClient = ApiClient();
    String apiUrl = APIConfig.imageBaseUrl;
    try {
      Response response = await apiClient.getData(apiUrl);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error: $e');
    }
  }
}
