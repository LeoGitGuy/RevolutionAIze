//Import Stuff
import 'dart:convert'; // to convert Json file
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart'; //imports http protocol
import 'package:shared_preferences/shared_preferences.dart';

//Classes
class Search extends StatelessWidget {
  const Search({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //coordinates
        Container(
          child: const Text('coordinates'
              //style: TextStyle(fontSize: 15),
              ),
        ),
        //time scale selection
        Container(
          child: const Text('Time scale selection'),
        ),
        // button
        Container(
          child: const Text('button'),
        ),
        //image
        Container(
          child: const Text('Image'),
        ),
        ProfileForm(pgCont: pgCont), //page counter
      ],
    ));
  }
}

class ProfileForm extends StatefulWidget {
  ProfileForm({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm>
    with AutomaticKeepAliveClientMixin<ProfileForm> {
  final vinController = TextEditingController();
  final nameController = TextEditingController();
  //ArticleService _vinService = ArticleService();

  @override
  void initState() {
    super.initState();
    //vinController.addListener(_sendValue);
  }

  @override
  void dispose() {
    vinController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _sendValue() {
    // give the value to the http widget
    //print("VIN is: ${vinController.text}");
    //_vinService.myVariable = vinController.text;
    //print("Singleton variable: ${_vinService.myVariable}");
  }

  /* void getArticles() {
    ServerHandler()
        .getArticles(_vinService.myVariable)
        .then((value) => Navigator.of(context)
            .pushNamed(ArticlesOverview.routeName, arguments: value))
        // ignore: invalid_return_type_for_catch_error
        .catchError((e) => print(e));
  } */

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final vinKey = 'my_vin';
    final vinValue = prefs.getString(vinKey) ?? "";
    //_vinService.myVariable = vinValue;
    //vinController.text = _vinService.myVariable;

    final nameKey = 'my_name';
    final nameValue = prefs.getString(nameKey) ?? "";
    nameController.text = nameValue;
  }

  _saveVin() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_vin';
    final value = vinController.text;
    prefs.setString(key, value);
    print('saved $value');
  }

  _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_name';
    final value = nameController.text;
    prefs.setString(key, value);
    print('saved $value');
  }

  @override
  Widget build(BuildContext context) {
    _read();
    super.build(context);
    double innerContainerWidth = MediaQuery.of(context).size.width - 100;
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Image.asset('assets/favicon.png'),
            SizedBox(height: 20),
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "User Profile",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.account_circle)
                  ],
                )),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                      width: innerContainerWidth,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),

                      //color: Colors.blue,
                      child: Column(
                        children: [
                          TextFormField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              this._saveName();
                            },
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.badge),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              this._saveVin();
                            },
                            controller: vinController,
                            decoration: InputDecoration(
                              labelText: 'VIN',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.pin,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                              onPressed: () {
                                this._sendValue();
                                this._saveVin();
                                this._saveName();
                                FocusScope.of(context).unfocus();
                                widget.pgCont();
                              },
                              icon: Icon(Icons.done,
                                  color: Colors.white, size: 22),
                              label: Text("SAVE3",
                                  style: const TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  textStyle: MaterialStateProperty.all(
                                      new TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(300, 40)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          side:
                                              BorderSide(color: Colors.grey))))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
