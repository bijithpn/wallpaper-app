import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:dio/dio.dart';
import 'package:wallpaper/details.dart';
import 'package:wallpaper/widget/parallax_swiper.dart';
import 'model/previewmodel.dart';

class PreviewGrid extends StatefulWidget {
  const PreviewGrid({
    super.key,
  });

  @override
  State<PreviewGrid> createState() => _PreviewGridState();
}

class _PreviewGridState extends State<PreviewGrid> {
  @override
  void initState() {
    getImages();
    super.initState();
  }

  List<Photo> photList = [];
  getImages() async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
        'RgVeYtR6GCFTjDpIUIlSOZ4jStiAQpz08H0QYuQIBMBE35fGIs7hrFWX';
    try {
      final res = await dio.get('https://api.pexels.com/v1/curated');
      var data = PreviewImage.fromJson(res.data);
      data.photos.map((e) => photList.add(e)).toList();
      print(photList[0].src.original);
      setState(() {});
    } catch (e) {
      print(e);
      if (e is DioException) {
        print(e.response?.data);
      }
      throw Exception(e);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Lastest"),
        ),
        body: photList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.custom(
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
                  (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(photoData: photList[index])));
                      },
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        imageUrl: photList[index].src.medium,
                        fit: BoxFit.cover,
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
                  childCount: photList.length,
                ),
              ));
  }
}
