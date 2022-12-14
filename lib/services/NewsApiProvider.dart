// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/connect.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsApiProvider extends GetConnect {
  // Get request
  Future<Response> getEveryThingAPI(Map<String, dynamic> params) {
    String getUrl = Uri.encodeFull(
        '${dotenv.env['EVERYTHING_API_URL']}?apiKey=${dotenv.env['API_KEY']}&q=${params['query']}&pageSize=${params['pageSize']}&page=${params['currentPage']}');
    debugPrint('getEveryThingAPI | getUrl : $getUrl');
    return get(getUrl);
  }

  // Get request
  Future<Response> getTopHeadingAPI(Map<String, dynamic> params) {
    String getUrl = Uri.encodeFull(
        '${dotenv.env['TOP_HEADING_API_URL']}?apiKey=${dotenv.env['API_KEY']}&q=${params['query']}&pageSize=${params['pageSize']}&page=${params['currentPage']}');
    debugPrint('getTopHeadingAPI | getUrl : $getUrl');
    return get(getUrl);
  }
}
