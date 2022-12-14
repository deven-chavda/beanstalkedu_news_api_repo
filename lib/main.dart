import 'dart:async';

import 'package:beanstalkedu_news_api/Screens/Bookmarks/BookmarksScreen.dart';
import 'package:beanstalkedu_news_api/utils/Utils.dart';
import 'package:beanstalkedu_news_api/utils/controller_binding.dart';
import 'package:beanstalkedu_news_api/utils/objectBoxStore/ObjectBoxStore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'Screens/EverythingAPI/EveryThingApiScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey');
RxInt mainNavCurrentSelectedTab = 0.obs;
GlobalKey<CurvedNavigationBarState> _mainNavBottomNavigationKey =
    GlobalKey(debugLabel: '_mainNavKey');

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

RxString mainScreenTxt = ''.obs;

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
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
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
        cardTheme: const CardTheme(color: Colors.white),
      ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          })),
      darkTheme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.black,
          primaryColorLight: Colors.black,
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          textTheme: const TextTheme(
            headline1: TextStyle(color: Colors.black),
            headline2: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
            subtitle1: TextStyle(color: Colors.black),
          ),
          // next line is important!
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light)),
      // // standard dark theme
      themeMode: ThemeMode.system,
      // device controls theme
      initialRoute: '/',
      getPages: [
        GetPage(
            name: Utils().routeConst['home']!,
            page: () => const MyHomePage(title: 'News API')),
      ],
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
  static final List<String> navTitles = ['Everything API', 'Bookmarks'];
  static final List<Widget> _mainNavItems = <Widget>[
    const EveryThingApiScreen(),
    const BookmarksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(() => Text(mainScreenTxt.value)),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _mainNavBottomNavigationKey,
        height: 50,
        index: mainNavCurrentSelectedTab.value,
        animationCurve: Curves.slowMiddle,
        backgroundColor: Colors.transparent,
        color: !isDarkMode ? Colors.blueAccent : Colors.grey,
        buttonBackgroundColor: !isDarkMode ? Colors.blueAccent:Colors.black,
        items: <Widget>[
          Utils().getCustomizedNavItem(Icons.home_outlined, 0, 'Home'),
          Utils()
              .getCustomizedNavItem(Icons.bookmarks_outlined, 1, 'Book Marks'),
        ],
        onTap: (index) {
          mainNavCurrentSelectedTab.value = index;
          mainScreenTxt.value = navTitles[index];
        },
      ),
      body: Obx(() => _mainNavItems.elementAt(mainNavCurrentSelectedTab.value)),
    );
  }

  @override
  void initState() {
    mainScreenTxt.value = navTitles[0];
    super.initState();
  }
}
