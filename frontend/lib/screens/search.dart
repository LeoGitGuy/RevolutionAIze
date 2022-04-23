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
import 'package:syncfusion_flutter_sliders/sliders.dart';

//Classes

class Search extends StatefulWidget {
  const Search({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  State<Search> createState() => _SearchState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _SearchState extends State<Search> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  //items for DropdownMenu
  String dropdownValue = 'Two Years';

  LocationService _locationService = LocationService();
  static const baseUrl = "http://127.0.0.1:8000/image";
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
            child: Text("Target Coordinates"),
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

  Widget imageViewer() {
    if (loadPressed) {
      return Image(
          height: 400,
          /* image: AssetImage("assets/rainforest.jpg"),
        height: 400,
      ); */
          image: NetworkImage(baseUrl +
              "?lat=" +
              _locationService.myLocation.latitude +
              "&lon=" +
              _locationService.myLocation.longitude));
    } else {
      return Text("Press the Red Button!");
    }
  }

  double _currentTimeValue = 2;
  double _currentMapSizeValue = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Headline
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
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
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: _coordinatesInput(),
              ),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const Text(
                          'Select Time Scale',
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _currentTimeValue,
                          max: 10,
                          divisions: 10,
                          label: _currentTimeValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentTimeValue = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: const Text(
                          'Select Map Size',
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _currentMapSizeValue,
                          max: 20,
                          divisions: 5,
                          label: _currentMapSizeValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentMapSizeValue = value;
                            });
                          },
                        ),
                      ),
                      /* Container(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
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
                      ), */
                      Expanded(
                        child: Text(""),
                      )
                      // ElevatedButton(onPressed: () {}, child: const Text('run')), //elevated button
                    ],
                  ),
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
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _locationService.myLocation = Location(
                                "test",
                                latitudeController.text,
                                longitudeController.text,
                                3);
                            setState(() {
                              loadPressed = true;
                            });
                          },
                          child: const Text('RUN')),
                    ),
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
        ),
      ),
    ));
  }
}
