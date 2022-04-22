import 'dart:async';

import '../models/article.dart';
import 'package:flutter/material.dart';

class ArticleService {
  static final ArticleService _instance = ArticleService._internal();

  // passes the instantiation to the _instance object
  factory ArticleService() => _instance;

  //initialize variables in here
  ArticleService._internal() {
    _myVIN = "";
    _myArticle = new Article();
    _newArticleUrl = "";
    myArticles = [];
  }

  String _myVIN = "";
  Article _myArticle = new Article();
  String _newArticleUrl = "";
  List<Article> myArticles = [];
  final textController = TextEditingController();
  StreamController<List<Article>> articleController =
      StreamController<List<Article>>.broadcast();

  void closeController() {
    articleController.close();
  }

  //short getter for newArticleUrl
  String get newArticleUrl => _newArticleUrl;

  //short setter for newArticleUrl
  set newArticleUrl(String value) => _newArticleUrl = value;

  //short getter for my variable
  String get myVariable => _myVIN;

  //short setter for my variable
  set myVariable(String value) => _myVIN = value;

  //short getter for single Article
  Article get myArticle => _myArticle;

  //short setter for single Article
  set myArticle(Article value) => _myArticle = value;
}
