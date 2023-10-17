import 'dart:io';
import 'dart:math';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/model/previewmodel.dart';
import 'package:flutter_wallpaper_app/screens/details/wallpaper_item.dart';
import 'dart:isolate';
import 'package:palette_generator/palette_generator.dart';

import 'wallpaper_isolate.dart';

enum WallpaperOption { homeScreen, lockScreen, both }

class DetailsPage extends StatefulWidget {
  final PreviewImage photoData;
  const DetailsPage({super.key, required this.photoData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

File file = File("");
int wallpaperStatus = 1;

class _DetailsPageState extends State<DetailsPage> {
  PaletteGenerator? paletteGenerator;
  @override
  void initState() {
    DefaultCacheManager()
        .getSingleFile(widget.photoData.urls.regular)
        .then((value) => file = value);
    updatePaletteGenerator();
    super.initState();
  }

  updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.photoData.urls.regular),
      maximumColorCount: 4,
    );
    if (!mounted) return;
    setState(() {});
  }

  ReceivePort imgReceive = ReceivePort();
  Future<bool> _setWallpaper() async {
    var result = await AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      wallpaperLocation: wallpaperStatus,
      goToHome: false,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );
    print(result);
    return result;
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
            color: paletteGenerator?.vibrantColor?.color ?? color,
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: color.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white),
                          ),
                          Text(
                            "${widget.photoData.user.portfolioUrl}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: color.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                paletteGenerator?.dominantColor?.color ??
                                    color.withOpacity(.5),
                            shape: const CircleBorder(),
                            elevation: 4),
                        onPressed: () async {
                          wallpaperStatus = await showDialog<int>(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        // height:
                                        //     MediaQuery.of(context).size.height /
                                        //         4,
                                        decoration: BoxDecoration(
                                            color: paletteGenerator
                                                    ?.lightVibrantColor
                                                    ?.color ??
                                                color,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            WallpaperItemWIdget(
                                              title: "Home Screen",
                                              color: paletteGenerator
                                                      ?.darkVibrantColor
                                                      ?.color ??
                                                  color,
                                              icon: Icons.home_rounded,
                                              function: () {
                                                Navigator.pop(context,
                                                    AsyncWallpaper.HOME_SCREEN);
                                              },
                                            ),
                                            WallpaperItemWIdget(
                                              title: "Lock Screen",
                                              color: paletteGenerator
                                                      ?.darkVibrantColor
                                                      ?.color ??
                                                  color,
                                              icon: Icons.lock_outline,
                                              function: () {
                                                Navigator.pop(context,
                                                    AsyncWallpaper.LOCK_SCREEN);
                                              },
                                            ),
                                            WallpaperItemWIdget(
                                              title: "Both Screen",
                                              color: paletteGenerator
                                                      ?.darkVibrantColor
                                                      ?.color ??
                                                  color,
                                              icon: Icons.wallpaper_outlined,
                                              function: () {
                                                Navigator.pop(
                                                    context,
                                                    AsyncWallpaper
                                                        .BOTH_SCREENS);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }) ??
                              AsyncWallpaper.BOTH_SCREENS;
                          var status = await computeIsolate(_setWallpaper);
                          print('sattus$status');
                        },
                        child: Icon(Icons.wallpaper,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.download,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_outline,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.blur_on_outlined,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white)),
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
