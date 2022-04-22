import 'dart:async';

import 'package:flutter/material.dart';
import '../models/article.dart';
import 'package:intl/intl.dart';

import '../server_handler.dart';
import '../services/article_service.dart';

class ArticlesOverview extends StatefulWidget {
  const ArticlesOverview({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _ArticlesOverviewState createState() => _ArticlesOverviewState();
}

class _ArticlesOverviewState extends State<ArticlesOverview> {
  ArticleService _vinService = ArticleService();

  String firstFewWords(String bigSentence) {
    int startIndex = 0, indexOfSpace = 0;

    for (int i = 0; i < 8; i++) {
      indexOfSpace = bigSentence.indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return bigSentence;
      }
      startIndex = indexOfSpace + 1;
    }

    return bigSentence.substring(0, indexOfSpace) + '...';
  }

  Widget _articleList() {
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
  }

  Widget _myListView() {
    _vinService.articleController.stream.listen((event) {
      setState(() {
        _vinService.myArticles = event;
      });
    });
    return ListView.builder(
      itemBuilder: (context, i) {
        final article = _vinService.myArticles[i];
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
                children: <Widget>[
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
                children: <Widget>[
                  Icon(
                    Icons.delete,
                  )
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            ServerHandler().deleteArticle(article.id).then((value) =>
                ServerHandler()
                    .getArticles(_vinService.myVariable)
                    .then((getValue) => _vinService.myArticles = getValue));
          },
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    "Are you sure you wish to delete this article?",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "DELETE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            elevation: 0,
            color: Color(0x33FFFFFF),
            shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  dense: true,
                  leading: Icon(Icons.article),
                  title: Text(article.title),
                  trailing: Column(
                    children: [
                      Text(
                        article.language,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(DateFormat("dd/MM").format(article.created))
                    ],
                  ),
                  subtitle: Text(firstFewWords(article.text)),
                  // enabled: _act == 2,
                  onTap: () {
                    print(article.language);
                    _vinService.myArticle = article;
                    //widget.onArticleChange(article);
                    widget.pgCont();
                  }),
            ),
          ),
        );
      },
      itemCount: _vinService.myArticles.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                children: [
                  Text(
                    "Article Overview",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.library_books)
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
            Expanded(child: _articleList()),
          ],
        ),
      ),
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

