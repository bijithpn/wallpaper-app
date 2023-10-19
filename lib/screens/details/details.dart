import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/provider/details_provider.dart';
import 'package:flutter_wallpaper_app/screens/author/author_page.dart';
import 'package:flutter_wallpaper_app/screens/details/wallpaper_item.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../db/favorite_type_adapter.dart';

enum WallpaperOption { homeScreen, lockScreen, both }

class DetailsPage extends StatefulWidget {
  final Photo photoData;
  const DetailsPage({super.key, required this.photoData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    // Provider.of<DetailsProvider>(context);
    super.initState();
  }

  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailsProvider>(
      lazy: false,
      create: (_) => DetailsProvider(photoData: widget.photoData),
      builder: (context, child) => Consumer<DetailsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: provider.color,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent.withOpacity(0),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded,
                      color: provider.color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthorWidget(
                                    profileUrl:
                                        provider.photoData!.photographerUrl)));
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: provider.color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ))
                ],
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CachedNetworkImage(
                    imageUrl: provider.photoData!.src.portrait,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 32,
                          color: Colors.red,
                        ),
                    placeholder: (context, url) => Image.network(
                          provider.photoData!.src.small,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Container(
                decoration: BoxDecoration(
                  color: provider.paletteGenerator?.vibrantColor?.color ??
                      provider.color,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                                        provider.photoData!.photographerUrl))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.photoData!.photographer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: provider.color
                                                      .computeLuminance() >
                                                  0.5
                                              ? Colors.black
                                              : Colors.white),
                                ),
                                Text(
                                  provider.photoData!.photographerUrl,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: provider.color
                                                      .computeLuminance() >
                                                  0.5
                                              ? Colors.black
                                              : Colors.white),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: provider.paletteGenerator
                                          ?.dominantColor?.color ??
                                      provider.color.withOpacity(.5),
                                  shape: const CircleBorder(),
                                  elevation: 4),
                              onPressed: () async {
                                provider
                                    .wallpaperStatus = await showDialog<int>(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: provider
                                                          .paletteGenerator
                                                          ?.lightVibrantColor
                                                          ?.color ??
                                                      provider.color,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  WallpaperItemWIdget(
                                                    title: "Home Screen",
                                                    color: provider
                                                            .paletteGenerator
                                                            ?.darkVibrantColor
                                                            ?.color ??
                                                        provider.color,
                                                    icon: Icons.home_rounded,
                                                    function: () {
                                                      Navigator.pop(
                                                          context,
                                                          AsyncWallpaper
                                                              .HOME_SCREEN);
                                                    },
                                                  ),
                                                  WallpaperItemWIdget(
                                                    title: "Lock Screen",
                                                    color: provider
                                                            .paletteGenerator
                                                            ?.darkVibrantColor
                                                            ?.color ??
                                                        provider.color,
                                                    icon: Icons.lock_outline,
                                                    function: () {
                                                      Navigator.pop(
                                                          context,
                                                          AsyncWallpaper
                                                              .LOCK_SCREEN);
                                                    },
                                                  ),
                                                  WallpaperItemWIdget(
                                                    title: "Both Screen",
                                                    color: provider
                                                            .paletteGenerator
                                                            ?.darkVibrantColor
                                                            ?.color ??
                                                        provider.color,
                                                    icon: Icons
                                                        .wallpaper_outlined,
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
                                // var status =
                                //     await computeIsolate(_setWallpaper());
                                // print('sattus$status');
                              },
                              child: Icon(Icons.wallpaper,
                                  color: provider.color.computeLuminance() > 0.5
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
                                color: provider.color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white)),
                        IconButton(
                            onPressed: () {
                              Box<Favorite> favoriteBooksBox =
                                  Hive.box('favoriteBox');
                              favoriteBooksBox.put(
                                  widget.photoData.id,
                                  Favorite(
                                    avgColor: widget.photoData.avgColor,
                                    height: widget.photoData.height.toString(),
                                    photographer: widget.photoData.photographer,
                                    id: widget.photoData.id,
                                    photographerUrl:
                                        widget.photoData.photographerUrl,
                                    imgSmall: widget.photoData.src.small,
                                    imgPortrait: widget.photoData.src.portrait,
                                    width: widget.photoData.width.toString(),
                                  ));
                              print('favo addecdx');
                            },
                            icon: provider.isFav
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(Icons.favorite_outline,
                                    color:
                                        provider.color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.blur_on_outlined,
                                color: provider.color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white)),
                      ],
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
