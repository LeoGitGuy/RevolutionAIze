import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'models/article.dart';
import 'package:flutter/material.dart';
import './screens/profile.dart';
import './screens/articles_overview.dart';
import './screens/add_article.dart';
import './screens/single_article.dart';
import './services/article_service.dart';
import 'server_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'BMW',
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
  ArticleService _vinService = ArticleService();
  var _selectedPageIndex;
  List<Widget> _pages = [];
  PageController _pageController = new PageController();
  Article singleArticle = new Article();

  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;

  final navigatorKey = GlobalKey<NavigatorState>();

  void show(value) {
    //final context = navigatorKey.currentState!.overlay!.context;
    OverlayEntry? entry;
    entry = OverlayEntry(builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(top: 25),
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
      ProfileScreen(
        pgCont: () => _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
        ),
      ),
      ArticlesOverview(
        pgCont: () => _pageController.jumpToPage(
          3,
        ),
      ),
      AddArticle(),
      SingleArticle(
        pgCont: () => _pageController.jumpToPage(
          1,
        ),
      )
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _handleSharedData(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? sharedValue) {
      final key = "my_vin";
      SharedPreferences.getInstance().then((value) => {
            _vinService.myVariable = value.getString(key) ?? "",
            _handleSharedData(sharedValue ?? "")
          });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _intentDataStreamSubscription.cancel();
    _vinService.closeController();
    super.dispose();
  }

  /// Handles any shared data we may receive.
  void _handleSharedData(String sharedText) {
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
  }

  void _getInitialList() {
    print(_vinService.myVariable);
    ServerHandler().getArticles(_vinService.myVariable).then(
        (value) => {_vinService.articleController.add(value), print(value)});
  }

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
        backgroundColor: Colors.white,
        leading: Image.asset("assets/bmwlogo.png"),
        elevation: 3.0,
        title: Text(
          "Personal Reader",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _pageController.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(Icons.account_circle, color: Colors.black)),
          IconButton(
              onPressed: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(Icons.list, color: Colors.black)),
          IconButton(
              onPressed: () {
                _pageController.animateToPage(2,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(Icons.plus_one_rounded, color: Colors.black))
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
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }
}
