import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/repository/image_repository.dart';

class HomeProvider with ChangeNotifier {
  bool isLoading = true;
  List<Photo> photoList = [];
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
}
