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

class SavedPlaces extends StatefulWidget {
  const SavedPlaces({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _SavedPlacesState createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  LocationService _locationService = LocationService();

/*   Widget _articleList() {
    //this.getArticles();
    //List<Article> articles =
    //    ModalRoute.of(context)!.settings.arguments as List<Article>;
    return FutureBuilder(
      //initialData: ServerHandler().getArticles(_vinService.myVariable),
      //stream: _vinService.articleController.stream,
      future: ServerHandler().getArticles(_vinService.myVariable),
      // ignore: non_constant_identifier_names
      builder: (context, AsyncSnapshot<List<Article>> articles) {
        if (articles.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()));
        } else if (articles.hasData == false) {
          //if (articles.hasData == false) {
          return Text(
            "Please enter a valid VIN first",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          );
        } else {
          print("new data");
          _vinService.myArticles = articles.data!;
          return _myListView();
        }
      },
    );
  } */

  Widget _myListView() {
    _locationService.locationController.stream.listen((event) {
      setState(() {
        _locationService.myLocations = event;
      });
    });
    return ListView.builder(
      itemBuilder: (context, i) {
        final location = _locationService.myLocations[i];
        return Dismissible(
          key: Key(i.toString()),
          background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red,
              ),
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                  )
                ],
              ),
            ),
          ),
          secondaryBackground: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red,
              ),
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                  )
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            _locationService.myLocations.removeAt(i);
          },
          child: Card(
            elevation: 0,
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  dense: true,
                  leading: Icon(Icons.explore_outlined),
                  title: Text(location.name),
                  trailing: Column(
                    children: [
                      Text(
                        location.latitude,
                        style: new TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        location.longitude,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  onTap: () {
                    _locationService.myLocation = location;
                    //widget.onArticleChange(article);
                    widget.pgCont();
                  }),
            ),
          ),
        );
      },
      itemCount: _locationService.myLocations.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        //color: Colors.grey,
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        alignment: Alignment.center,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Text(
                    "Favorite Places",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.explore_outlined)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey,
              thickness: 3,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(child: _myListView()),
          ],
        ),
      ),
    );
  }
}
