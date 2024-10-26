import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_app/db/favorite_type_adapter.dart';
import 'package:flutter_wallpaper_app/data/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/screens/details/details.dart';
import 'package:flutter_wallpaper_app/utils/color_extentions.dart';

class CustomGridView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<QuiltedGridTile> patterns;
  final void Function()? onTap;
  final List<dynamic> list;
  const CustomGridView({
    super.key,
    this.scrollController,
    this.patterns = const [
      QuiltedGridTile(4, 2),
      QuiltedGridTile(3, 2),
      QuiltedGridTile(4, 2),
      QuiltedGridTile(4, 2),
    ],
    this.onTap,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GridView.custom(
        controller: scrollController,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          pattern: patterns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            var photo = list[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                key: ValueKey(photo.id),
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 450),
                          pageBuilder: (_, __, ___) =>
                              DetailsPage(photoData: photo)));
                  //MaterialPageRoute(
                  // builder: (context) => DetailsPage(photoData: photo))
                },
                child: Hero(
                  tag: photo.id,
                  child: CachedNetworkImage(
                    width: photo.runtimeType == Favorite
                        ? double.parse((photo.width.toString())) / 25
                        : double.parse(photo.width.toString()),
                    height: photo.runtimeType == Favorite
                        ? double.parse(photo.height.toString()) / 25
                        : double.parse(photo.height.toString()),
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        width: photo.runtimeType == Favorite
                            ? double.parse((photo.width.toString())) / 25
                            : double.parse(photo.width.toString()),
                        height: photo.runtimeType == Favorite
                            ? double.parse(photo.height.toString()) / 25
                            : double.parse(photo.height.toString()),
                      ),
                    ),
                    imageUrl: photo.runtimeType == Favorite
                        ? (photo as Favorite).imgPortrait
                        : (photo as Photo).src.portrait,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: HexColor.fromHex(photo.avgColor),
                      width: photo.runtimeType == Favorite
                          ? double.parse((photo.width.toString())) / 35
                          : double.parse(photo.width.toString()),
                      height: photo.runtimeType == Favorite
                          ? double.parse(photo.height.toString()) / 35
                          : double.parse(photo.height.toString()),
                      child: Image.network(
                        photo.runtimeType == Favorite
                            ? photo.imgSmall
                            : photo.src.small,
                        fit: BoxFit.cover,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.align_vertical_bottom_outlined,
                        size: 32,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }
}
