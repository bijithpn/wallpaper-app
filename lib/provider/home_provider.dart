import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/data/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/data/repository/image_repository.dart';

class HomeProvider with ChangeNotifier {
  bool isLoading = false;
  List<Photo> photoList = [];
  List<Photo> searchPhotoList = [];
  late ScrollController scrollController;
  int pageIndex = 1;
  int dataLimit = 50;
  ImageRepository imageRepository = ImageRepository();
  HomeProvider() {
    getImages();
    scrollController = ScrollController();
    scrollController.addListener(getMoreImage);
  }
  getMoreImage() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      List<Photo> tempList = [];
      pageIndex += 1;
      var body = {'page': pageIndex, 'per_page': dataLimit};
      var paginatedimageData =
          await imageRepository.imageAPICall(queryParameters: body);
      paginatedimageData.photos.map((e) => tempList.add(e)).toList();
      if (tempList.isNotEmpty) {
        photoList.addAll(tempList);
        notifyListeners();
      }
    }
  }

  getImages() async {
    try {
      isLoading = true;
      notifyListeners();
      var body = {'page': pageIndex, 'per_page': dataLimit};
      var imageData = await imageRepository.imageAPICall(queryParameters: body);
      imageData.photos.map((e) => photoList.add(e)).toList();
      if (photoList.isNotEmpty) {
        isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  searchImage(String query) async {
    try {
      isLoading = true;
      searchPhotoList.clear();
      var body = {'query': query};
      var imageData =
          await imageRepository.searchAPICall(queryParameters: body);
      imageData.photos.map((e) => searchPhotoList.add(e)).toList();
      if (searchPhotoList.isNotEmpty) {
        isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
}
