import 'package:beanstalkedu_news_api/utils/connection_manager_controller.dart';
import 'package:beanstalkedu_news_api/utils/controller_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinding(),
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              color: Colors.blue, foregroundColor: Colors.white)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  RxInt counter = 0.obs;

  void _incrementCounter() {
    counter = counter++;
  }

  @override
  Widget build(BuildContext context) {
    final ConnectionManagerController controller =
        Get.find<ConnectionManagerController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${dotenv.env['ESCAPED_DOLLAR_SIGN']}',
            ),
            Obx(() => Text(
                  controller.connectionType.value == 1
                      ? "Wifi Connected"
                      : controller.connectionType.value == 2
                          ? 'Mobile Data Connected'
                          : 'No Internet',
                  style: Theme.of(context).textTheme.headline4,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
