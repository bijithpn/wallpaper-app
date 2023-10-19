import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class ImageDownloadProvider extends ChangeNotifier {
  Saf saf = Saf('/Download/');
  List<String>? paths = [];
  ImageDownloadProvider() {
    loadPath();
  }
  updatePath() async {
    Permission.storage.request();
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: true);

    if (isGranted != null && isGranted) {
      paths?.clear();
      paths = await Saf.getPersistedPermissionDirectories();
      notifyListeners();
      if (paths?.isNotEmpty ?? false) {}
    }
  }

  bool fileExists(String filePath) {
    final file = File(filePath);
    return file.existsSync();
  }

  loadPath() async {
    paths?.clear();
    paths = await Saf.getPersistedPermissionDirectories();
    if (paths?.isNotEmpty ?? false) {
      return paths?.first ?? "n/a";
    }
  }

  Future<void> saveImage(File file, BuildContext context) async {
    var permission = await Saf.getPersistedPermissionDirectories();
    if (permission?.isEmpty ?? true) {
      await requestPermission();
    }
    permission = await Saf.getPersistedPermissionDirectories();

    File imageFile = File(
        '/storage/emulated/0/${permission!.first}/${file.path.split('/').last}');
    if (!fileExists(imageFile.path)) {
      await imageFile.writeAsBytes(await file.readAsBytes());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("file downloaded")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("file already downloaded")));
    }
  }

  Future<void> requestPermission() async {
    Permission.storage.request();
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: true);
    if (isGranted != null && isGranted) {
      // Perform some file operation
    } else {
      throw 'failed to get the permission';
    }
  }
}
