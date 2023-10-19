import 'dart:ui';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter_wallpaper_app/provider/provider.dart';
import 'package:flutter_wallpaper_app/screens/author/author_page.dart';
import 'package:flutter_wallpaper_app/screens/details/wallpaper_item.dart';
import 'package:provider/provider.dart';

enum WallpaperOption { homeScreen, lockScreen, both }

class DetailsPage extends StatefulWidget {
  final Photo photoData;
  const DetailsPage({super.key, required this.photoData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ConfettiController confettiController;

  bool isFav = false;
  bool setWallpapaer = false;
  bool isLoading = false;
  bool isBlur = false;
  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
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
              body: Stack(
                children: [
                  CachedNetworkImage(
                      imageUrl: provider.photoData!.src.large2X,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaY: isBlur ? 5 : 0, sigmaX: isBlur ? 5 : 0),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                        confettiController: confettiController,
                        createParticlePath: drawStar,
                        blastDirection: pi / 2,
                        maxBlastForce: 8,
                        minBlastForce: 5,
                        emissionFrequency: 0.05,
                        numberOfParticles: 10, // a lot of particles at once
                        gravity: 1,
                        blastDirectionality: BlastDirectionality.explosive),
                  ),
                ],
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
                                color: provider.paletteGenerator?.dominantColor
                                        ?.color ??
                                    provider.color.withOpacity(.5),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        provider.photoData!.photographerUrl))),
                            child:
                                const Icon(Icons.photo_camera_front_outlined),
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
                                setWallpapaer = await provider.setWallpaper(
                                    wallpaperLocation: provider.wallpaperStatus,
                                    context: context);
                                setState(() {});
                                if (setWallpapaer) {
                                  confettiController.play();
                                }
                              },
                              child: Icon(
                                  !setWallpapaer ? Icons.wallpaper : Icons.done,
                                  color: provider.color.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              Provider.of<ImageDownloadProvider>(context,
                                      listen: false)
                                  .saveImage(provider.file, context);
                            },
                            icon: Icon(Icons.download,
                                color: provider.color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white)),
                        Consumer<FavoriteProvider>(
                          builder: (context, fav, _) {
                            isFav = fav.getFavoriteFromId(widget.photoData.id);
                            return IconButton(
                                onPressed: () {
                                  if (fav
                                      .getFavoriteFromId(widget.photoData.id)) {
                                    fav.removeFavorite(widget.photoData.id);
                                  } else {
                                    fav.addToFavorite(widget.photoData);
                                  }
                                  isFav = fav
                                      .getFavoriteFromId(widget.photoData.id);
                                },
                                icon: isFav
                                    ? const Icon(Icons.favorite,
                                        color: Colors.red)
                                    : Icon(Icons.favorite_outline,
                                        color:
                                            provider.color.computeLuminance() >
                                                    0.5
                                                ? Colors.black
                                                : Colors.white));
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              isBlur = !isBlur;
                              setState(() {});
                            },
                            icon: Icon(
                                isBlur
                                    ? Icons.blur_circular_outlined
                                    : Icons.blur_on_outlined,
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
