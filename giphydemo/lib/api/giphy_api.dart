import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:giphy_demo/models/giphy_model.dart';
import 'package:http/http.dart' as http;

class GiphyApi {
  //Future<List<Map<String, dynamic>>>
  static searchGiphy(String query) async {
    final String url =
        "https://api.giphy.com/v1/gifs/search?api_key=SkxnmoQWbOBypzmjgUZHfhRtooGmc9an&q=$query&limit=25&offset=0&rating=g&lang=en";
    try {
      final response = await http.get(Uri.parse(url));
      //   final dataString = await loadAsset("assets/jsonData/data.json");
      final Map<String, dynamic> mapData =
          convert.jsonDecode(response.body); //{}
      final listData =
          mapData['data'] as List; //List<dynamic> // List<Map<String,dynamic>>
      //final data = listData.map((e) => e as Map<String, dynamic>).toList();
      final data = listData.map((e) => GiphyModel.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw "Oops error is $e";
    }
  }

  static Future<String> loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}
