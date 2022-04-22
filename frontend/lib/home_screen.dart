//Import Stuff
import 'dart:convert'; // to convert Json file
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart'; //imports http protocol

//Classes
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDescending = true;
  bool alphabetically = false;

  @override //redefining the build function of Stateless Widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to make the government transparent - fast',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /*Description*/
          Container(
            child: const Text(
              'Due to the Open Data paragraph, every ministry is obliged to provide data. Find here a simple tool to see which ministry has already done how much! Data is provided by a template but will be updatet in the future by an API.',
              style: TextStyle(fontSize: 15),
            ),
            color: Colors.white,
            padding: EdgeInsets.all(15),
          ),
          const Divider(
            height: 1.0,
            thickness: 2.0,
            endIndent: 30.0,
            indent: 30.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Sort By:',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Number of datasets'),
              buildSwitch(),
              Text('Alphabetically'),
            ],
          ),
          TextButton.icon(
            icon: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.compare_arrows, size: 28),
            ),
            label: Text(
              isDescending ? 'Descending' : 'Ascending',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () => setState(() => isDescending = !isDescending),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Divider(
            height: 1.0,
            thickness: 2.0,
            endIndent: 30.0,
            indent: 30.0,
          ),
          /*2* List*/
          Expanded(
              //When use a Scrollable Widget inside a Column, expand it
              child: FutureBuilder(
                  future: readJsonData(),
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text("${data.error}"));
                    } else if (data.hasData) {
                      var items = data.data as List<GovData>;
                      return ListView.builder(
                          itemCount: items == null ? 0 : items.length,
                          itemBuilder: (context, index) {
                            var sortedItems = items;
                            if (!alphabetically) {
                              sortedItems = items
                                ..sort((item1, item2) => isDescending
                                    ? item2.datasets.compareTo(item1.datasets)
                                    : item1.datasets.compareTo(item2.datasets));
                            } else {
                              sortedItems = items
                                ..sort((item1, item2) => isDescending
                                    ? item2.department.toUpperCase().compareTo(
                                        item1.department.toUpperCase())
                                    : item1.department.toUpperCase().compareTo(
                                        item2.department.toUpperCase()));
                            }

                            final item = sortedItems[index];

                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Text(
                                              item.department.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child:
                                                Text(item.datasets.toString()),
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
        ],
      ),
    );
  }

  Widget buildSwitch() => Transform.scale(
        scale: 1.4,
        child: Switch.adaptive(
          // activeColor: Colors.blue,
          //activeTrackColor: Colors.blue.withOpacity(0.4),
          inactiveThumbColor: Colors.orange,
          inactiveTrackColor: Colors.orange.withOpacity(0.4),
          value: alphabetically,
          onChanged: (byDataset) =>
              setState(() => this.alphabetically = !alphabetically),
        ),
      );

  Future<List<GovData>> readJsonData() async {
    final jsondata = await rootBundle.rootBundle
        .loadString('lib/assets/backend-response.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list
        .map((e) => GovData.fromJson(e))
        .toList(); //reads Data from Json and sends it to a map
  }
}
