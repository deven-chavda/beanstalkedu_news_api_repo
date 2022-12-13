// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class Utils {
  // This class is for writing re-usable functions and etc.
  var routeConst = {'home': '/'};

  showSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor:
          title.toLowerCase().contains('error') ? Colors.red : Colors.grey,
      snackPosition: SnackPosition.BOTTOM,
      borderColor:
          title.toLowerCase().contains('error') ? Colors.red : Colors.grey,
      borderRadius: 20,
      borderWidth: 2,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  validateQueryText(String query) {
    if (query.isEmpty) {
      return 'Please enter some text';
    } else if (query.length < 3) {
      return 'Please enter minimum 3 chars';
    }
    return null;
  }

  List<String> getPageSizeList() {
    return ['5', '10', '15'];
  }

  // getAndStoreArticles(String query) async {
  //   Response res = await NewsApiProvider().getEveryThingAPI(query);
  //   Map<String, dynamic> body = json.decode(json.encode(res.body));
  //   debugPrint('BODY : ${body['status']}');
  //   debugPrint('BODY totalResults : ${body['totalResults']}');
  //   if (body['status'] == 'error' || body['totalResults'] <= 0) {
  //     debugPrint('No Article Available');
  //     return;
  //   } else if (body['status'] == 'ok') {
  //     debugPrint('BODY : ${body['articles'][0]['source']['id']}');
  //     var box = objectbox.store.box<ArticlesEntity>();
  //     for (var article in body['articles']) {
  //       var articleEntity = ArticlesEntity(
  //           article['author'] ?? '',
  //           article['title'] ?? '',
  //           article['content'] ?? '',
  //           article['description'] ?? '',
  //           article['publishedAt'] ?? '',
  //           article['url'] ?? '',
  //           article['urlToImage'] ?? '');
  //       articleEntity.articleSource.target = ArticleSourceEntity(
  //           article['source']['id'] ?? '', article['source']['name'] ?? '');
  //       box.put(articleEntity);
  //     }
  //   }
  // }

  getCustomizedNavItem(IconData icon, int index, String navTxt) {
    return Obx(() => SizedBox(
          height: mainNavCurrentSelectedTab.value == index ? 30 : 50,
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 30, color: Colors.white),
                Visibility(
                    visible:
                        mainNavCurrentSelectedTab.value == index ? false : true,
                    child: Text(navTxt))
              ],
            ),
          ),
        ));
  }
}
