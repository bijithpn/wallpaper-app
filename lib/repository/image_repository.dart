import 'package:dio/dio.dart';
import 'package:flutter_wallpaper_app/api_config/api_client.dart';
import 'package:flutter_wallpaper_app/api_config/api_config.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';

class ImageRepository {
  Future<ImageData> imageAPICall(
      {Map<String, dynamic>? queryParameters}) async {
    ApiClient apiClient = ApiClient();
    String apiUrl = APIConfig.imageBaseUrl + APIEndpoints.curated;
    try {
      Response response =
          await apiClient.getData(apiUrl, queryParameters: queryParameters);
      var imageData = ImageData.fromJson(response.data);
      return imageData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Photo> imageDetailsAPICall(
      {Map<String, dynamic>? queryParameters}) async {
    ApiClient apiClient = ApiClient();
    String apiUrl = APIConfig.imageBaseUrl + APIEndpoints.getPhoto;
    try {
      Response response =
          await apiClient.getData(apiUrl, queryParameters: queryParameters);
      var imageData = Photo.fromJson(response.data);
      return imageData;
    } catch (e) {
      rethrow;
    }
  }

  Future<ImageData> searchAPICall(
      {Map<String, dynamic>? queryParameters}) async {
    ApiClient apiClient = ApiClient();
    String apiUrl = APIConfig.imageBaseUrl + APIEndpoints.search;
    try {
      Response response =
          await apiClient.getData(apiUrl, queryParameters: queryParameters);
      var imageData = ImageData.fromJson(response.data);
      return imageData;
    } catch (e) {
      rethrow;
    }
  }
}
