import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/provider/favorites_provider.dart';
import 'package:flutter_wallpaper_app/widget/custom_grid_view.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favorite, _) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            favorite.getFavotiteItem();
          });
          if (favorite.favoriteItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    "Please add your favorite wallpaper",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          } else {
            return CustomGridView(
                scrollController: favorite.scrollController,
                list: favorite.favoriteItems);
          }
        },
      ),
    );
  }
}
