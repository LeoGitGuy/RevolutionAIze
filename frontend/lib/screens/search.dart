//Import Stuff
// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors

import 'dart:convert'; // to convert Json file
//import 'dart:html';
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart'; //imports http protocol
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_handler.dart';
import '../models/location.dart';

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
  //items for DropdownMenu
  String dropdownValue = 'Two Years';

  LocationService _locationService = LocationService();
  static const baseUrl = "http://test.de";
  var loadPressed = false;

  Widget _coordinatesInput() {
    latitudeController.text = _locationService.myLocation.latitude;
    longitudeController.text = _locationService.myLocation.longitude;
    return Align(
      alignment: Alignment.center, //this also doesn't work
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment
            .center, //Center Row contents vertically, //why doesn't this work haha??
        children: [
          const Expanded(
            child: Text("1. Type in coordinates of target:"),
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
      ),
    );
  }

  var buttonPressed = false;
  Widget imageViewer() {
    if (loadPressed) {
      return Image(
          image: NetworkImage(baseUrl +
              "?lat=" +
              _locationService.myLocation.latitude +
              "&lon=" +
              _locationService.myLocation.longitude));
    } else {
      return Text("4. Enjoy result image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Headline
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center, //how to allign headline??
            child: Row(
              children: const [
                Text(
                  "Use Custom Search Engine",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                ),
                SizedBox(width: 20),
                Icon(Icons.image_search_outlined)
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 20,
            color: Colors.grey,
            thickness: 3,
            endIndent: 30.0,
            indent: 30.0,
          ),
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
            alignment: Alignment.center,
            child: Row(
              children: [
                const Text(
                  '2. Select time scale in which you want to see environmental changes of your location',
                ),
                Container(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    elevation: 30,
                    style: const TextStyle(color: Colors.blue),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.blue,
                    // ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Two Years',
                      'Three Years',
                      'Four Years',
                      'Five Years'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // ElevatedButton(onPressed: () {}, child: const Text('run')), //elevated button
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
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('3. Press button to run model'),
                ElevatedButton(
                    onPressed: () {
                      _locationService.myLocation = Location("test",
                          latitudeController.text, longitudeController.text, 3);
                      setState(() {
                        buttonPressed = true;
                      });
                    },
                    child: const Text('run')),
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
          Container(child: imageViewer()),
          //ProfileForm(pgCont: pgCont), //page counter
        ],
      ),
    ));
  }
}
