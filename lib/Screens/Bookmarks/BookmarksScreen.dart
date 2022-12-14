import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../objectbox.g.dart';
import '../../utils/objectBoxEntities/NewsApiEntities.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Box<BookmarkArticlesEntity> box =
        objectbox.store.box<BookmarkArticlesEntity>();
    List<BookmarkArticlesEntity> bookmarkList = box.getAll();

    return bookmarkList.isEmpty
        ? const Center(child: Text('No Bookmarks here! You can add'))
        : ListView.separated(
            itemBuilder: (context, index) {
              var article = bookmarkList[index];
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
                              child: article.urlToImage.length > 3
                                  ? CachedNetworkImage(
                                      imageUrl: article.urlToImage,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
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
                                        surfaceTintColor: !isDarkMode?Colors.blue:Colors.grey,
                                        color: !isDarkMode?Colors.blue:Colors.black,
                                        shadowColor: !isDarkMode?Colors.blue:Colors.grey,
                                        elevation: !isDarkMode?15:25,
                                        child: IconButton(
                                            onPressed: () {
                                              box.remove(article.id);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.bookmark_outline,
                                              color: Colors.white,
                                            )),
                                      )),
                                  Visibility(
                                    visible: article.description.length > 3
                                        ? true
                                        : false,
                                    child: Text(
                                        "description : ${article.description}",
                                        maxLines: 3,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis)),
                                  )
                                ]),
                              )),
                        ],
                      ),
                      Text(
                        'Title : ${article.title}',
                        maxLines: 1,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      // Text(
                      //     'Published At : ${DateFormat.yMEd().add_jms().format(DateTime.parse(publishedAt))}'),
                      Visibility(
                          visible: article.author.length > 3 ? true : false,
                          child: Text('Author : ${article.author}')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible:
                                article.articleSource.target!.sourceID.length >
                                        3
                                    ? true
                                    : false,
                            child: Flexible(
                              child: Text(
                                'source id : ${article.articleSource.target!.sourceID}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Visibility(
                              visible: article.articleSource.target!.sourceID
                                          .length >
                                      3
                                  ? true
                                  : false,
                              child: const Text('|')),
                          Visibility(
                            visible:
                                article.articleSource.target!.name.length > 3
                                    ? true
                                    : false,
                            child: Flexible(
                              child: Center(
                                child: Text(
                                  'source name : ${article.articleSource.target!.name}',
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
            },
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
            itemCount: bookmarkList.length);
  }
}
