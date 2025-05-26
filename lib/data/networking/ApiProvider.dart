import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  final String _baseUrl1 = 'https://api.datamuse.com/sug';

  Future<List<dynamic>> searchWord(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl1?s=$word'));
      if(response.statusCode == 200) {
        var responseJSon = json.decode(response.body.toString());
        return responseJSon;
      } else {
        return List.empty();
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<List<dynamic>> findDetailWord(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$word'));
      if(response.statusCode == 200) {
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      } else {
        return List.empty();
      }
    } catch(e) {
      rethrow;
    }
  }
}