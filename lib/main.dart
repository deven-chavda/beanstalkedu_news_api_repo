import 'dart:async';

import 'package:beanstalkedu_news_api/Screens/Bookmarks/BookmarksScreen.dart';
import 'package:beanstalkedu_news_api/utils/Utils.dart';
import 'package:beanstalkedu_news_api/utils/controller_binding.dart';
import 'package:beanstalkedu_news_api/utils/objectBoxStore/ObjectBoxStore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'Screens/EverythingAPI/EveryThingApiScreen.dart';
import 'Screens/TopHeadlinesAPI/TopHeadlinesApiScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey');
RxInt mainNavCurrentSelectedTab = 0.obs;
GlobalKey<CurvedNavigationBarState> _mainNavBottomNavigationKey =
    GlobalKey(debugLabel: '_mainNavKey');

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    objectbox = await ObjectBox.create();
  } catch (e) {
    debugPrint('main.dart | CATCH | $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinding(),
      navigatorKey: navigatorKey,
      title: 'News',
      theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              appBarTheme: const AppBarTheme(
                  color: Colors.blue, foregroundColor: Colors.white),
              cardTheme: const CardTheme(color: Colors.white))
          .copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          })),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: Utils().routeConst['home']!,
            page: () => const MyHomePage(title: 'News API')),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<String> navTitles = [
    'Everything API',
    'Top headlines API',
    'Bookmarks'
  ];
  static final List<Widget> _mainNavItems = <Widget>[
    const EveryThingApiScreen(),
    const TopHeadlinesApiScreen(),
    const BookmarksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(() => Text(navTitles[mainNavCurrentSelectedTab.value])),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _mainNavBottomNavigationKey,
        height: 50,
        index: mainNavCurrentSelectedTab.value,
        animationCurve: Curves.slowMiddle,
        backgroundColor: Colors.lightBlueAccent,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent,
        items: <Widget>[
          Utils().getCustomizedNavItem(Icons.home_outlined, 0, 'Home'),
          Utils().getCustomizedNavItem(Icons.topic_outlined, 1, 'Top Heading'),
          Utils()
              .getCustomizedNavItem(Icons.bookmarks_outlined, 2, 'Book Marks'),
        ],
        onTap: (index) {
          mainNavCurrentSelectedTab.value = index;
        },
      ),
      body: Obx(() => _mainNavItems.elementAt(mainNavCurrentSelectedTab.value)),
    );
  }
}
