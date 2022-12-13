import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetails extends StatefulWidget {
  final String articleUrl;

  const ArticleDetails(this.articleUrl, {Key? key}) : super(key: key);

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  RxBool isLoading = true.obs;
  RxDouble progress = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text('Article View')),
      body: Obx(() => Stack(
            children: [
              WebView(
                  initialUrl: widget.articleUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  backgroundColor: const Color(0x00000000),
                  onPageFinished: (finish) {
                    isLoading.value = false;
                  },
                  onProgress: (int currentProgress) {
                    progress.value = currentProgress / 100;
                    print("WebView is loading (progress : $currentProgress%)");
                  }),
              isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        value: progress.value,
                      ),
                    )
                  : Stack()
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
}
