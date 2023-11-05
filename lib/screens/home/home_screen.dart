import 'package:flutter/material.dart';

import 'package:flutter_wallpaper_app/provider/home_provider.dart';
import 'package:flutter_wallpaper_app/screens/favorites/favorite.dart';
import 'package:flutter_wallpaper_app/screens/search/search.dart';
import 'package:flutter_wallpaper_app/screens/settings/settings.dart';
import 'package:flutter_wallpaper_app/widget/custom_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool shoButton = false;
  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.length > 3) {
        shoButton = true;
      } else {
        shoButton = false;
      }
      setState(() {});
    });
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: SizedBox(
              height: 50,
              child: TextFormField(
                cursorWidth: 1,
                controller: controller,
                autofillHints: const [
                  AutofillHints.location,
                  AutofillHints.name,
                  AutofillHints.photo
                ],
                onFieldSubmitted: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                                query: value,
                              )));
                  controller.clear();
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    hintText: "Trending..",
                    suffixIcon: shoButton
                        ? AnimatedOpacity(
                            opacity: shoButton ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              query: controller.text,
                                            )));
                                controller.clear();
                              },
                              icon: const Icon(Icons.search),
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.camera_enhance))
            ],
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
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
                                  .copyWith(fontWeight: FontWeight.bold),
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
                                  .copyWith(fontWeight: FontWeight.bold),
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
