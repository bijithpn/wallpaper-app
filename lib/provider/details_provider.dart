import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:hive/hive.dart';
import 'package:palette_generator/palette_generator.dart';

import '../db/favorite_type_adapter.dart';
import '../utils/color_extentions.dart';

class DetailsProvider with ChangeNotifier {
  final Photo? photoData;
  late Color color;
  bool isFav = false;
  int wallpaperStatus = 1;
  PaletteGenerator? paletteGenerator;
  File file = File("");
  DetailsProvider({this.photoData}) {
    color = HexColor.fromHex(photoData!.avgColor);
    DefaultCacheManager()
        .getSingleFile(photoData!.src.portrait)
        .then((value) => file = value);
    getFavorite(photoData!.id);
    updatePaletteGenerator();
  }
  updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(photoData!.src.portrait),
      maximumColorCount: 4,
    );
    notifyListeners();
  }

  getFavorite(int id) {
    Box<Favorite> favoriteBooksBox = Hive.box('favoriteBox');
    if (favoriteBooksBox.containsKey(id)) {
      isFav = true;
      notifyListeners();
    }
  }

  setWallpaper(
      {required int wallpaperLocation, required BuildContext context}) async {
    var status = await AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      wallpaperLocation: wallpaperLocation,
      goToHome: false,
    );
    return status;
  }
}
