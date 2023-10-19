import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_app/db/favorite_type_adapter.dart';
import 'package:flutter_wallpaper_app/model/image_data_model.dart';
import 'package:flutter_wallpaper_app/screens/details/details.dart';
import 'package:flutter_wallpaper_app/utils/color_extentions.dart';

class CustomGridView extends StatelessWidget {
  final ScrollController scrollController;
  final List<QuiltedGridTile> patterns;
  final void Function()? onTap;
  final List<dynamic> list;
  const CustomGridView({
    super.key,
    required this.scrollController,
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsPage(photoData: photo)));
                },
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  imageUrl: photo.runtimeType == Favorite
                      ? (photo as Favorite).imgPortrait
                      : (photo as Photo).src.portrait,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: HexColor.fromHex(photo.avgColor),
                    width: double.parse(photo.width.toString()),
                    height: double.parse(photo.height.toString()),
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
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }
}
