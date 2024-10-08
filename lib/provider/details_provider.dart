import 'dart:io';
import 'package:flutter/services.dart';
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

  Future<bool> setWallpaper() async {
    try {
      const platform = MethodChannel('com.example.wallpaper/wallpaper');
      final int result = await platform.invokeMethod('setWallpaper', {
        'imagePath': file.path,
        'type': getWallpaperType(wallpaperStatus),
      });
      if (result == 1) {
        return true;
      }
    } on PlatformException catch (e) {
      print("Failed to set wallpaper: '${e.message}'.");
    }
    return false;
  }

  String getWallpaperType(int value) {
    switch (value) {
      case 1:
        return "home";
      case 2:
        return 'lock';
      case 3:
        return "both";
      default:
        return "home";
    }
  }
}
