import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/db/favorite_type_adapter.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/repository/image_repository.dart';
import 'package:hive/hive.dart';

class FavoriteProvider with ChangeNotifier {
  late Box<Favorite> favoriteWallpaperBox;
  late ScrollController scrollController;
  ImageRepository imageRepository = ImageRepository();
  List<Favorite> favoriteItems = [];

  FavoriteProvider() {
    favoriteWallpaperBox = Hive.box('favoriteBox');
    scrollController = ScrollController();
  }
  bool getFavoriteFromId(int id) {
    Box<Favorite> favoriteBooksBox = Hive.box('favoriteBox');
    if (favoriteBooksBox.containsKey(id)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  getFavotiteItem() {
    favoriteItems = favoriteWallpaperBox.values.toList();
    notifyListeners();
  }

  addToFavorite(Photo photoData) {
    favoriteWallpaperBox.put(
        photoData.id,
        Favorite(
          avgColor: photoData.avgColor,
          height: photoData.height.toString(),
          photographer: photoData.photographer,
          id: photoData.id,
          photographerUrl: photoData.photographerUrl,
          imgSmall: photoData.src.small,
          imgPortrait: photoData.src.portrait,
          width: photoData.width.toString(),
        ));
  }

  removeFavorite(int id) {
    if (favoriteWallpaperBox.containsKey(id)) {
      favoriteWallpaperBox.delete(id);
      notifyListeners();
    }
  }
}
