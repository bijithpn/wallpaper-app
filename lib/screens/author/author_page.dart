import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthorWidget extends StatefulWidget {
  final String profileUrl;
  const AuthorWidget({
    Key? key,
    required this.profileUrl,
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
        appBar: AppBar(title: const Text('Flutter Simple Example')),
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
                if (url.contains('intent://') || url.contains('upi://')) {
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
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Colors.pink,
                    )),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
