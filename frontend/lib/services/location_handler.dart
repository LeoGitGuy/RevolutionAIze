import 'dart:async';

import '../models/overview_widget.dart';
import '../models/location.dart';

import 'package:flutter/material.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  // passes the instantiation to the _instance object
  factory LocationService() => _instance;

  //initialize variables in here
  LocationService._internal() {
    //_myVIN = "";
    _myLocation = Location("", "", "", 1);
    //_newArticleUrl = "";
    myLocations = [
      Location("test1", "111", "222", 2),
      Location("test2", "111", "222", 2),
      Location("test3", "111", "222", 2),
    ];
  }

  //String _myVIN = "";
  Location _myLocation = Location("", "", "", 1);
  //String _newArticleUrl = "";
  List<Location> myLocations = [
    Location("test1", "111", "222", 2),
    Location("test2", "111", "222", 2),
    Location("test3", "111", "222", 2),
  ];
  final textController = TextEditingController();
  StreamController<List<Location>> locationController =
      StreamController<List<Location>>.broadcast();

  void closeController() {
    locationController.close();
  }

  //short getter for newArticleUrl
  //String get newArticleUrl => _newArticleUrl;

  //short setter for newArticleUrl
  //set newArticleUrl(String value) => _newArticleUrl = value;

  //short getter for my variable
  //String get myVariable => _myVIN;

  //short setter for my variable
  //set myVariable(String value) => _myVIN = value;

  //short getter for single Article
  Location get myLocation => _myLocation;

  //short setter for single Article
  set myLocation(Location value) => _myLocation = value;
}
