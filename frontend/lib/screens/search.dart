//Import Stuff
// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors

import 'dart:convert'; // to convert Json file
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart'; //imports http protocol
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_handler.dart';

//Classes
class Search extends StatefulWidget {
  const Search({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  LocationService _locationService = LocationService();
  Widget _coordinatesInput() {
    latitudeController.text = _locationService.myLocation.latitude;
    longitudeController.text = _locationService.myLocation.longitude;
    return Row(
      children: [
        const Expanded(
          child: Text("Coordinates of target:"),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: latitudeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Latitude here',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: longitudeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Longitude here',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          //coordinates
          _coordinatesInput(),
          const Divider(
            height: 10.0,
            thickness: 2.0,
            endIndent: 30.0,
            indent: 30.0,
            color: Colors.grey,
          ),
          //time scale selection
          Container(
            child: Column(
              children: [
                const Text(
                  'Select time scale in which you want to see environmental changes',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('run')),
              ],
            ),
          ),
          // button
          const Divider(
            height: 10.0,
            thickness: 2.0,
            endIndent: 30.0,
            indent: 30.0,
            color: Colors.grey,
          ),
          Container(
            child: Column(
              children: [
                const Text('here comes the button'),
                ElevatedButton(onPressed: () {}, child: const Text('run')),
              ],
            ),
          ),
          const Divider(
            height: 10.0,
            thickness: 2.0,
            endIndent: 30.0,
            indent: 30.0,
            color: Colors.grey,
          ),
          //image
          Container(
            child: const Text(
              'image',
              style: TextStyle(fontSize: 15),
            ),
            color: Colors.green.shade600,
            padding: const EdgeInsets.all(15),
          ),
          //ProfileForm(pgCont: pgCont), //page counter
        ],
      ),
    ));
  }
}
