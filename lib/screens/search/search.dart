import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter_wallpaper_app/provider/home_provider.dart';
import 'package:flutter_wallpaper_app/widget/custom_grid_view.dart';

class SearchPage extends StatefulWidget {
  final String query;
  const SearchPage({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    context.read<HomeProvider>().searchImage(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Search result",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<HomeProvider>(builder: (_, state, __) {
        return state.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: SystemTheme.accentColor.accent,
                ),
              )
            : CustomGridView(
                list: state.searchPhotoList,
              );
      }),
    );
  }
}
