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
import '../models/location.dart';
import '../services/location_handler.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  //ArticleService _vinService = ArticleService();
  LocationService _locationService = LocationService();

  final List<OverviewWidget> _items = [
    OverviewWidget("assets/desert.jpg", "Desert",
        Location("test", "desert_lat", "desert_long", 2)),
    OverviewWidget("assets/rainforest.jpg", "Rainforest",
        Location("test", "rainforest_lat", "rainforest_long", 2)),
    OverviewWidget("assets/munich.jpg", "Urban",
        Location("test", "urban_lat", "urban_long", 2)),
    OverviewWidget("assets/farm.jpg", "Farming",
        Location("test", "farm_lat", "farm_long", 2)),
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
                _locationService.myLocation = _items[index].location;
                widget.pgCont();
              },
              child: Container(
                child: Center(
                  child: Text(_items[index].name,
                      style: TextStyle(
                          background: Paint()
                            ..color = Colors.white
                            ..strokeWidth = 38
                            ..style = PaintingStyle.stroke,
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                height: 190.0,
                width: MediaQuery.of(context).size.width - 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                    image: DecorationImage(
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
