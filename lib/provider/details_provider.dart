import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:hive/hive.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

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

  updatePath() async {
    // await Saf.releasePersistedPermissions();
    // List<String>? paths = await Saf.getPersistedPermissionDirectories();

    Permission.storage.request();
    Saf saf = Saf('/Download/');
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: true);

    if (isGranted != null && isGranted) {
      List<String>? paths = await Saf.getPersistedPermissionDirectories();

      if (paths?.isNotEmpty ?? false) {}
    }
  }

  downloadImage() async {
    List<String>? paths = await Saf.getPersistedPermissionDirectories();
    if (paths?.isNotEmpty ?? false) {
      //  paths?.first ?? 'n/a',
    }
  }

  getFavorite(int id) {
    Box<Favorite> favoriteBooksBox = Hive.box('favoriteBox');
    if (favoriteBooksBox.containsKey(id)) {
      isFav = true;
      notifyListeners();
    }
  }

  _setWallpaper() {
    AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      wallpaperLocation: 1,
      goToHome: false,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );
    // print(result);
    // return result;
  }
}
