import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_wallpaper_app/provider/home_provider.dart';
import 'package:flutter_wallpaper_app/screens/home/widget/image_tab_tile.dart';
import 'package:provider/provider.dart';

import '../../utils/color_extentions.dart';
import '../details/details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBar(
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
                title: SizedBox(
                  height: 50,
                  child: TextFormField(
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        hintText: "Trending..",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        fillColor: Colors.grey[600],
                        filled: true),
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.camera_enhance))
                ],
                bottom: TabBar(
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    indicator: const BoxDecoration(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    tabs: [
                      ImageTabTile(
                        imageURl: 'https://pixy.org/src/20/201310.jpg',
                        title: "Trending",
                      ),
                      ImageTabTile(
                        imageURl:
                            'https://www.imagelighteditor.com/img/bg-after.jpg',
                        title: "Featured",
                      ),
                      ImageTabTile(
                        imageURl: 'https://pixy.org/src/21/219269.jpg',
                        title: "Popular",
                      ),
                      ImageTabTile(
                        imageURl:
                            'https://furbo.org/color/Downloads/Image-ProPhoto.jpg',
                        title: "Most Liked",
                      ),
                    ])),
          ),
          drawer: Drawer(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DrawerHeader(
                      child: Center(
                    child: Text(
                      "Pick your wallpaper",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
                  const ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Favorite"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Setting"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.share_outlined),
                    title: Text("Share"),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Build by ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            const FlutterLogo()
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Designed by Bijith",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20)
                ]),
          ),
          body: Consumer<HomeProvider>(builder: (context, homeProvider, _) {
            return homeProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
          })),
    );
  }
}
