import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:beanstalkedu_news_api/utils/objectBoxEntities/NewsApiEntities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../services/NewsApiProvider.dart';
import '../../utils/Utils.dart';
import 'ArticleDetails.dart';

class EveryThingApiScreen extends StatefulWidget {
  const EveryThingApiScreen({Key? key}) : super(key: key);

  @override
  State<EveryThingApiScreen> createState() => _EveryThingApiScreenState();
}

class _EveryThingApiScreenState extends State<EveryThingApiScreen> {
  RxString query = 'everything'.obs, currentApi = 'Everything'.obs;
  RxInt currentPage = 1.obs, currentPageSize = 10.obs;
  List<String> pageSizeLst = Utils().getPageSizeList();
  List<String> apiLst = Utils().getApiList();
  late Future currentApiFuture;
  final _formKey = GlobalKey<FormState>();
  Box<BookmarkArticlesEntity> box =
      objectbox.store.box<BookmarkArticlesEntity>();

  bool isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  updateEverythingApi() {
    Map<String, dynamic> params = {
      'query': query.value.length < 3 ? 'everything' : query.value,
      'pageSize': currentPageSize.value,
      'currentPage': currentPage.value
    };
    setState(() {
      currentApiFuture = currentApi.value == 'Everything'
          ? NewsApiProvider().getEveryThingAPI(params)
          : NewsApiProvider().getTopHeadingAPI(params);
    });
  }

  Widget getPageChangeWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.41,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Select API'),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding: EdgeInsets.all(5),
                ),
                child: Obx(() => DropdownButton<String>(
                      value: currentApi.value,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_downward_outlined),
                      borderRadius: BorderRadius.circular(12),
                      elevation: 24,
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          currentApi.value = value.toString();
                          mainScreenTxt.value = '${value.toString()} API';
                          updateEverythingApi();
                        });
                      },
                      items:
                          apiLst.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Per Page'),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding: EdgeInsets.all(5),
                ),
                child: Obx(() => DropdownButton<String>(
                      value: currentPageSize.value.toString(),
                      underline: Container(),
                      icon: const Icon(Icons.arrow_downward_outlined),
                      borderRadius: BorderRadius.circular(12),
                      elevation: 24,
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          currentPageSize.value = int.parse(value ?? '10');
                          updateEverythingApi();
                        });
                      },
                      items: pageSizeLst
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Current Page'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () => currentPage.value > 1
                        ? {currentPage = currentPage--, updateEverythingApi()}
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    // child: const Text('-')
                  ),
                  Obx(() => Text(currentPage.value.toString())),
                  IconButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () =>
                        {currentPage = currentPage++, updateEverythingApi()},
                    icon: const Icon(Icons.add_circle_outline),
                    // child: const Text('+')
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  updateState() {
    setState(() {});
  }

  Widget getListItemsCard(List articlesArr) {
    return Expanded(
      flex: 3,
      child: ListView.separated(
        itemCount: articlesArr.length + 1,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        // reverse: true,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (articlesArr.isEmpty) {
            return const Text('No Data available to show!');
          }
          if (index == articlesArr.length && articlesArr.isNotEmpty) {
            return getPageChangeWidget();
          }
          var article = articlesArr[index];
          return OpenContainer(
            transitionDuration: const Duration(milliseconds: 800),
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (context, action) {
              var isBookmarkedList = box
                  .getAll()
                  .where((element) => element.url == article['url']);
              return GestureDetector(
                onTap: action,
                child: Utils().getCard(
                    article,
                    isBookmarkedList.toList(),
                    box,
                    updateState,
                    currentApi.value,
                    currentPageSize.value,
                    currentPage.value,
                    isDarkMode),
              );
            },
            openBuilder: (context, action) {
              return ArticleDetails(article['url']);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(navigator!.context).requestFocus(FocusNode()),
      child: SizedBox(
        height: MediaQuery.of(navigator!.context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(navigator!.context).size.height * 0.21,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        Utils()
                                            .showSnackBar('info', 'processing');
                                        updateEverythingApi();
                                        return;
                                      }
                                    },
                                    icon: const Icon(Icons.search_rounded)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: 'Enter a Query',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (text) {
                                query.value = text;
                              },
                              // The validator receives the text that the user has entered.
                              validator: (value) =>
                                  Utils().validateQueryText(value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 18),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        getPageChangeWidget(),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Close'),
                                        )
                                      ]),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Advance Search',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.blue),
                          ))),
                  // getPageChangeWidget()
                ],
              ),
            ),
            FutureBuilder(
              future: currentApiFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Try again later!');
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> body =
                      json.decode(json.encode(snapshot.data?.body));
                  if (body['status'] == 'error') {
                    return Center(child: Text(body['message']));
                  } else if (body['status'] == 'ok') {
                    if (body['totalResults'] <= 0) {
                      return const Text('No Data Available');
                    }
                    return getListItemsCard(body['articles']);
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    currentApiFuture = NewsApiProvider().getEveryThingAPI({
      'query': query.value.length < 3 ? 'everything' : query.value,
      'pageSize': currentPageSize.value,
      'currentPage': currentPage.value
    });
    super.initState();
  }
}
