import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  final String url;
  const MainPage({super.key, required this.url});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey webViewKey = GlobalKey();

  String url = '';
  String title = '';
  double progress = 0;
  bool? isSecure;
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.blue,
  );

  bool canGoBack = true;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (canGoBack) {
          webViewController!.goBack();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: InAppWebView(
            key: webViewKey,
            pullToRefreshController: pullToRefreshController,
            initialSettings: InAppWebViewSettings(
              allowsBackForwardNavigationGestures: true,
              // useShouldOverrideUrlLoading: true,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url),
            ),
            onWebViewCreated: (controller) async {
              webViewController = controller;
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
                await controller.startSafeBrowsing();
              }
            },
            // shouldOverrideUrlLoading: (controller, navigationAction) async {
            //   var url = navigationAction.request.url;

            //   if (url!.scheme.startsWith("whatsapp")) {
            //     try {
            //       await launch(
            //         'whatsapp://send/?phone=628111116005',
            //         forceSafariVC: false,
            //         forceWebView: false,
            //         universalLinksOnly: true,
            //       );
            //       return NavigationActionPolicy.CANCEL;
            //     } catch (e) {
            //       print("Error launching WhatsApp: $e");
            //     }
            //     return NavigationActionPolicy.ALLOW;
            //   }
            // },
            onLoadStart: (controller, url) async {
              const String phoneNumber = "628111116005";
              const String whatsappUrl =
                  "https://api.whatsapp.com/send?phone=$phoneNumber";
              // print('ini urlnya = $url');

              if (url != null) {
                if (url.scheme.startsWith("whatsapp")) {
                  try {
                    await launch(
                      whatsappUrl,
                      forceSafariVC: false,
                      forceWebView: false,
                      universalLinksOnly: true,
                    );
                  } catch (e) {
                    // print('Error launching WhatsApp: $e');
                  }
                }
              }

              // Proses URL lainnya sesuai kebutuhan
              if (url != null) {
                setState(() {
                  this.url = url.toString();
                });
              }
              // print('ini url scheme: ${url?.scheme}');
            },
            onLoadStop: (controller, url) {
              pullToRefreshController?.endRefreshing();
            },
            onTitleChanged: (controller, title) {
              if (title != null) {
                setState(() {
                  this.title = title;
                });
              }
            },
            onReceivedError: (controller, request, error) async {
              pullToRefreshController?.endRefreshing();
              controller.goBack();
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController?.endRefreshing();
              }
            },
          ),
        ),
      ),
    );
  }

  void handleClick(int item) async {
    switch (item) {
      case 0:
        await InAppBrowser.openWithSystemBrowser(url: WebUri(url));
        break;
      case 1:
        await InAppWebViewController.clearAllCache();
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          await webViewController?.clearHistory();
        }
        setState(() {});
        break;
    }
  }

  // ignore: unused_element
  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || isLocalizedContent(url);
  }

  static bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" ||
        url.scheme == "chrome" ||
        url.scheme == "data" ||
        url.scheme == "javascript" ||
        url.scheme == "about");
  }
}
