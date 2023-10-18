import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/model/previewmodel.dart';

class AuthorWidget extends StatefulWidget {
  final User usrData;
  const AuthorWidget({
    Key? key,
    required this.usrData,
  }) : super(key: key);

  @override
  State<AuthorWidget> createState() => _AuthorWidgetState();
}

class _AuthorWidgetState extends State<AuthorWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter Simple Example')),
        body: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.usrData.profileImage.large),
            )
          ],
        ));
  }
}
