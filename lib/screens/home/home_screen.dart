import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_wallpaper_app/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/color_extentions.dart';
import '../details/details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Trending"),
        ),
        body: Consumer<HomeProvider>(builder: (context, homeProvider, _) {
          return homeProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.custom(
                    controller: homeProvider.scrollController,
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 4,
                      pattern: const [
                        QuiltedGridTile(4, 2),
                        QuiltedGridTile(3, 2),
                        QuiltedGridTile(4, 2),
                        QuiltedGridTile(4, 2),
                      ],
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var photo = homeProvider.photoList[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsPage(photoData: photo)));
                            },
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  ClipRRect(
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              imageUrl: photo.src.medium,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: HexColor.fromHex(photo.avgColor),
                                width: double.parse(photo.width.toString()),
                                height: double.parse(photo.height.toString()),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.align_vertical_bottom_outlined,
                                  size: 32,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: homeProvider.photoList.length,
                    ),
                  ),
                );
        }));
  }
}
