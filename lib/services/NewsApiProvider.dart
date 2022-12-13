// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/connect.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsApiProvider extends GetConnect {
  // Get request
  Future<Response> getEveryThingAPI(
      String query, int pageSize, int currentPage) {
    String getUrl =
        '${dotenv.env['EVERYTHING_API_URL']}?q=$query&apiKey=${dotenv.env['API_KEY']}&pageSize=$pageSize&page=$currentPage';
    debugPrint('getEveryThingAPI | getUrl : $getUrl');
    return get(getUrl);
  }

  // Get request
  Future<Response> getTopHeadingAPI(
      String query, int pageSize, int currentPage) {
    String getUrl =
        '${dotenv.env['TOP_HEADING_API_URL']}?q=$query&apiKey=${dotenv.env['API_KEY']}&pageSize=$pageSize&page=$currentPage';
    debugPrint('getTopHeadingAPI | getUrl : $getUrl');
    return get(getUrl);
  }
}
