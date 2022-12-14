// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../objectbox.g.dart';
import 'objectBoxEntities/NewsApiEntities.dart';

class Utils {
  // This class is for writing re-usable functions and etc.
  var routeConst = {'home': '/'};
  var s = "This project doesn't need any implementation, just you may need some commands in terminal";

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

  List<String> getApiList() {
    return ['Everything', 'Top headlines'];
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
    return Obx(() => Container(
          color: Colors.transparent,
          height: mainNavCurrentSelectedTab.value == index ? 30 : 50,
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 30, color: Colors.white),
                Visibility(
                    visible:
                        mainNavCurrentSelectedTab.value == index ? false : true,
                    child: Text(
                      navTxt,
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget getCard(
      Map<String, dynamic> article,
      List<BookmarkArticlesEntity> isBookmarkedList,
      Box<BookmarkArticlesEntity> box,
      Function() updateState,
      String currentApi,
      int pageSize,
      int currentPage) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: article['urlToImage'] != null
                        ? CachedNetworkImage(
                            imageUrl: article['urlToImage'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: Card(
                              surfaceTintColor: isBookmarkedList.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey,
                              color: isBookmarkedList.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey,
                              shadowColor: isBookmarkedList.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey,
                              elevation: 15,
                              child: IconButton(
                                  onPressed: () {
                                    BookmarkArticlesEntity
                                        bookmarkArticlesEntity =
                                        BookmarkArticlesEntity(
                                            article['author'] ?? '',
                                            article['title'] ?? '',
                                            article['content'] ?? '',
                                            article['description'] ?? '',
                                            article['publishedAt'] ?? '',
                                            article['url'] ?? '',
                                            article['urlToImage'] ?? '',
                                            currentApi,
                                            pageSize.toString(),
                                            currentPage.toString());
                                    bookmarkArticlesEntity
                                            .articleSource.target =
                                        BookmarkArticleSourceEntity(
                                            article['source']['id'] ?? '',
                                            article['source']['name'] ?? '');
                                    try {
                                      if (isBookmarkedList.isEmpty) {
                                        box.put(bookmarkArticlesEntity);
                                      } else {
                                        box.remove(isBookmarkedList.first.id);
                                      }
                                    } catch (e) {
                                      debugPrint(
                                          'bookmarkArticlesEntity put exception : $e');
                                    }
                                    updateState();
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_outline,
                                    color: Colors.white,
                                  )),
                            )),
                        Visibility(
                          visible:
                              article['description'] != null ? true : false,
                          child: Text("description : ${article['description']}",
                              maxLines: 3,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis)),
                        )
                      ]),
                    )),
              ],
            ),
            Text(
              'Title : ${article['title']}',
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            // Text(
            //     'Published At : ${DateFormat.yMEd().add_jms().format(DateTime.parse(publishedAt))}'),
            Visibility(
                visible: article['author'] != null ? true : false,
                child: Text('Author : ${article['author']}')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: article['source']['id'] != null ? true : false,
                  child: Flexible(
                    child: Text(
                      'source id : ${article['source']['id']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Visibility(
                    visible: article['source']['id'] != null ? true : false,
                    child: const Text('|')),
                Visibility(
                  visible: article['source']['name'] != null ? true : false,
                  child: Flexible(
                    child: Center(
                      child: Text(
                        'source name : ${article['source']['name']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
