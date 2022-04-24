// Import Stuf //
// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart';
import 'screens/home_screen.dart';
import './screens/overview.dart';
import './screens/saved_places.dart';
import './screens/search.dart';

void main() {
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromARGB(255, 42, 136, 14),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MaterialColor colorCustom = MaterialColor(0xFF3DA5A2, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RevolutionAIze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorCustom,
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 61, 165, 162),
        scaffoldBackgroundColor: Color.fromARGB(255, 2, 61, 65), // Color Appbar

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(),
      //routes: {ArticlesOverview.routeName: (_) => const ArticlesOverview()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //ArticleService _vinService = ArticleService();
  var _selectedPageIndex;
  List<Widget> _pages = [];
  PageController _pageController = new PageController();
  //Article singleArticle = new Article();

  //late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;

  final navigatorKey = GlobalKey<NavigatorState>();

  void show(value) {
    //final context = navigatorKey.currentState!.overlay!.context;
    OverlayEntry? entry;
    entry = OverlayEntry(builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(top: 25),
        backgroundColor: Colors.black,
        title: const Text(
          "Article Uploaded",
          style: TextStyle(color: Colors.white),
        ),
        content: const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 40,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => entry!.remove(),
            child: const Text(
              "O.K.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    });
    Navigator.of(context).overlay!.insert(entry);
  }

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      Overview(
        pgCont: () => _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
        ),
      ),
      SavedPlaces(
        pgCont: () => _pageController.jumpToPage(
          3,
        ),
      ),
      //AddArticle(),
      Search(
        pgCont: () => _pageController.jumpToPage(
          1,
        ),
      )
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    /*  _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _handleSharedData(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    }); */

    // For sharing or opening urls/text coming from outside the app while the app is closed
    /* ReceiveSharingIntent.getInitialText().then((String? sharedValue) {
      final key = "my_vin";
      SharedPreferences.getInstance().then((value) => {
            _vinService.myVariable = value.getString(key) ?? "",
            _handleSharedData(sharedValue ?? "")
          });
    }); */
  }

  @override
  void dispose() {
    _pageController.dispose();
    //_intentDataStreamSubscription.cancel();
    //_vinService.closeController();
    super.dispose();
  }

  /// Handles any shared data we may receive.
  /* void _handleSharedData(String sharedText) {
    setState(() {
      this._sharedText = sharedText;
      print(sharedText);
      if (sharedText != "") {
        //_selectedPageIndex = 2;
        _vinService.newArticleUrl = sharedText;
        _vinService.textController.text = sharedText;
        ServerHandler().postArticle(_vinService.myVariable, sharedText).then(
            (postValue) => {this.show(postValue), this._getInitialList()});
        /*  _pageController.animateToPage(2,
            duration: Duration(milliseconds: 300), curve: Curves.bounceIn); */
      }
    });
  } */

  /* void _getInitialList() {
    print(_vinService.myVariable);
    ServerHandler().getArticles(_vinService.myVariable).then(
        (value) => {_vinService.articleController.add(value), print(value)});
  } */

/*   void pgCont(pg) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(pg,
          duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 165, 162), // Color Scaffold
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
          child: Image.asset(
            "assets/World_Vision_ohne_text_richtiger_hintergrund.png",
            width: 150,
            height: 100,
          ),
        ),
        elevation: 10.0,
        title: const Center(
          child: const Text(
            "World Vision",
            style: const TextStyle(fontSize: 40, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: const Icon(Icons.apps_outlined, color: Colors.black)),
          IconButton(
              onPressed: () {
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: const Icon(Icons.favorite_outline, color: Colors.black)),
          IconButton(
              onPressed: () {
                _pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: const Icon(Icons.travel_explore_outlined,
                  color: Colors.black))
        ],
      ),
      backgroundColor: Colors.transparent,
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }
}


// Main Function
/* void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: HomeScreen(), //we could imagine more sides/ screen
    )); */
