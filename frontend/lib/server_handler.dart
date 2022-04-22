import 'package:http/http.dart' as http;
import 'dart:convert';

import './models/article.dart';

class ServerHandler {
  final String _baseUrl = "18.197.247.197:54321";

  // get the list of articles
  Future<List<Article>> getArticles(String vin) async {
    try {
      List<Article> articles = [];
      final queryParameters = {
        '#articles': '15',
      };
      final uri = Uri.http(_baseUrl, '/articles/vin/' + vin, queryParameters);
      http.Response response = await http.get(uri);
      List articlesList = (json.decode(response.body));

      for (Map m in articlesList) {
        articles.add(Article.fromMap(m));
      }
      print('Inside Vin: ' + vin);
      print(response.body);
      //print(articles[0].created);
      return articles;
    } catch (e) {
      print("Server Handler: error : " + e.toString());
      throw e;
    }
  }

  Future<Article> postArticle(String vin, String articleUrl) async {
    try {
      print("VIN: $vin");
      print("URL: $articleUrl");
      Article article = new Article();
      final uri = Uri.http(_baseUrl, "/articles/");
      http.Response response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'vin': vin, 'articleUrl': articleUrl}));

      article = Article.fromMap(json.decode(response.body));
      print(article.title);
      return article;
    } catch (e) {
      print("Server Handler: error : " + e.toString());
      throw e;
    }
  }

  Future<String> deleteArticle(int id) async {
    try {
      final uri = Uri.http(_baseUrl, '/articles/single/' + id.toString());
      http.Response response = await http.delete(uri);

      //print(response.body);
      //print(articles[0].created);
      return "Article deleted";
    } catch (e) {
      print("Server Handler: error : " + e.toString());
      throw e;
    }
  }

  Future<String> deleteArticles(String vin) async {
    try {
      final uri = Uri.http(_baseUrl, '/articles/vin/' + vin);
      http.Response response = await http.delete(uri);

      //print(response.body);
      //print(articles[0].created);
      return "Article deleted";
    } catch (e) {
      print("Server Handler: error : " + e.toString());
      throw e;
    }
  }
}
