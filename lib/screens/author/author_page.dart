import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthorWidget extends StatefulWidget {
  final String profileUrl;
  final Color color;
  const AuthorWidget({
    Key? key,
    required this.profileUrl,
    required this.color,
  }) : super(key: key);

  @override
  State<AuthorWidget> createState() => _AuthorWidgetState();
}

class _AuthorWidgetState extends State<AuthorWidget> {
  bool isLoading = true;
  InAppWebViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back,
                    color: widget.color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white)),
            backgroundColor: widget.color,
            title: Text(
              'Photographer profile',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white),
            )),
        body: Stack(
          children: [
            InAppWebView(
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                });
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                ),
              ),
              initialUrlRequest:
                  URLRequest(url: Uri.tryParse(widget.profileUrl)),
              onWebViewCreated: (InAppWebViewController controller) {},
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {},
              onUpdateVisitedHistory:
                  (InAppWebViewController controller, Uri? uri, __) async {},
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                if (url.contains('https://')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onCloseWindow: (controller) {
                controller.clearCache();
              },
            ),
            isLoading
                ? Container(
                    color: widget.color,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: widget.color,
                    )),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
