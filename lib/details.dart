import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:wallpaper/model/previewmodel.dart';
import 'dart:isolate';

enum WallpaperOption { homeScreen, lockScreen, both }

class DetailsPage extends StatefulWidget {
  final PreviewImage photoData;
  const DetailsPage({super.key, required this.photoData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ReceivePort imgReceive = ReceivePort();
  wallpaperCallback(WallpaperOption option) async {
    switch (option) {
      case WallpaperOption.homeScreen:
        await Isolate.spawn(
            setWallpaper(widget.photoData.urls.regular, context, 1),
            imgReceive.sendPort);
        print(imgReceive);
        break;
      case WallpaperOption.lockScreen:
        await Isolate.spawn(
            setWallpaper(widget.photoData.urls.regular, context, 2),
            imgReceive.sendPort);
        break;
      case WallpaperOption.both:
        await Isolate.spawn(
            setWallpaper(widget.photoData.urls.regular, context, 3),
            imgReceive.sendPort);
        break;
    }
  }

  setWallpaper(String url, BuildContext context, int wallpaperLocation) {
    wallpaperSet(url, wallpaperLocation);
  }

  wallpaperSet(String url, int wallpaperLocation) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    final res = await WallpaperManager.setWallpaperFromFile(
        file.path, wallpaperLocation);
    if (res) {
      switch (wallpaperLocation) {
        case 1:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('A new Perks is applied at your home screen.')));
          break;
        case 2:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('A new Perks is applied at your lock screen.')));
          break;
        case 3:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'A new Perks applied at your both home and lock screen.')));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = HexColor.fromHex(widget.photoData.color);
    return Scaffold(
        backgroundColor: color,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CachedNetworkImage(
              imageUrl: widget.photoData.urls.raw,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 32,
                    color: Colors.red,
                  ),
              placeholder: (context, url) => Image.network(
                    widget.photoData.urls.thumb,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.photoData.user.profileImage.large))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.photoData.user.firstName}${widget.photoData.user.lastName}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${widget.photoData.user.portfolioUrl}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), elevation: 4),
                        onPressed: () async {
                          wallpaperSet(widget.photoData.urls.full, 1);
                        },
                        child: const Icon(Icons.wallpaper_rounded))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.blur_on_outlined,
                        color: Colors.white,
                      )),
                ],
              )
            ],
          ),
        ));
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
