//Import Stuff
// ignore_for_file: prefer_const_constructors

import 'dart:convert'; // to convert Json file
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart'; //imports http protocol
import 'package:shared_preferences/shared_preferences.dart';
import '../models/overview_widget.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  //ArticleService _vinService = ArticleService();

  final List<OverviewWidget> _items = [
    OverviewWidget("assets/desert.jpg", "Desert"),
    OverviewWidget("assets/rainforest.jpg", "Rainforest"),
    OverviewWidget("assets/munich.jpg", "Urban"),
    OverviewWidget("assets/farm.jpg", "Farming"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.pgCont();
              },
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(_items[index].image))),
              ),
            );
          }),
    );
  }
}

/*   void getArticles() {
    ServerHandler()
        .getArticles()
        .then((value) => {this.articles = value, print("Articles Loaded")})
        // ignore: invalid_return_type_for_catch_error
        .catchError((e) => print(e));
  } */
