import 'package:flutter/material.dart';

import 'package:flutter_wallpaper_app/provider/home_provider.dart';
import 'package:flutter_wallpaper_app/screens/favorites/favorite.dart';
import 'package:flutter_wallpaper_app/screens/home/widget/image_tab_tile.dart';
import 'package:flutter_wallpaper_app/screens/settings/settings.dart';
import 'package:flutter_wallpaper_app/widget/custom_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

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
                bottom: const TabBar(
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(),
                    padding: EdgeInsets.symmetric(vertical: 10),
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
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text("Favorite"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritePage()));
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                    leading: const Icon(Icons.settings),
                    title: const Text("Setting"),
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
                ? Center(
                    child: CircularProgressIndicator(
                      color: SystemTheme.accentColor.accent,
                    ),
                  )
                : CustomGridView(
                    scrollController: homeProvider.scrollController,
                    list: homeProvider.photoList,
                  );
          })),
    );
  }
}
