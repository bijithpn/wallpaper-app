import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:dio/dio.dart';
import 'package:wallpaper/details.dart';
import 'model/previewmodel.dart';

class PreviewGrid extends StatefulWidget {
  const PreviewGrid({
    super.key,
  });

  @override
  State<PreviewGrid> createState() => _PreviewGridState();
}

class _PreviewGridState extends State<PreviewGrid> {
  late ScrollController scrollController;
  int pageIndex = 1;
  @override
  void initState() {
    getImages();
    scrollController = ScrollController();
    scrollController.addListener(loadMore);
    super.initState();
  }

  List<PreviewImage> photList = [];
  Future<List<PreviewImage>> imageApiCall() async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
        'Client-ID BwWaasVrSfwp1gIpZD2C0EPJM9Rc6_nhzFYDzTYL7UU';
    final res = await dio.get('https://api.unsplash.com/photos',
        queryParameters: {"page": pageIndex});
    var json = jsonEncode(res.data);
    return previewImageFromJson(json);
  }

  getImages() async {
    try {
      photList = await imageApiCall();
      setState(() {});
    } catch (e) {
      if (e is DioException) {}
      throw Exception(e);
    }
  }

  loadMore() async {
    if (scrollController.position.pixels + 600 >
        scrollController.position.maxScrollExtent) {
      pageIndex += 1;
      List<PreviewImage> data = await imageApiCall();
      if (data.isNotEmpty) {
        photList.addAll(data);
        setState(() {});
      }
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Trending"),
        ),
        body: photList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.custom(
                  controller: scrollController,
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
                          imageUrl: photList[index].urls.small,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: HexColor.fromHex(photList[index].color),
                            width:
                                double.parse(photList[index].width.toString()),
                            height:
                                double.parse(photList[index].height.toString()),
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
                    childCount: photList.length,
                  ),
                ),
              ));
  }
}
