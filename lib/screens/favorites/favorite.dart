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
      body: Consumer<FavoriteProvider>(
        builder: (context, favorite, _) {
          favorite.getFavotiteItem();
          return CustomGridView(
              scrollController: favorite.scrollController,
              list: favorite.favoriteItems);
        },
      ),
    );
  }
}
