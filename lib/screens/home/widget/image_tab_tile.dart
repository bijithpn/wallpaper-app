import 'package:flutter/material.dart';

class ImageTabTile extends StatelessWidget {
  final String imageURl;
  final String title;

  const ImageTabTile({
    super.key,
    required this.imageURl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.difference),
              image: NetworkImage(imageURl),
              fit: BoxFit.cover)),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
