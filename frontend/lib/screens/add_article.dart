import "package:flutter/material.dart";

import '../server_handler.dart';
import '../services/article_service.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  ArticleService _vinService = ArticleService();
  var articleUrlController = TextEditingController();
  var sharedUrl = "";
  @override
  void initState() {
    super.initState();
    articleUrlController = _vinService.textController;
  }

  @override
  Widget build(BuildContext context) {
    double innerContainerWidth = MediaQuery.of(context).size.width - 100;
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Add an Article",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.add_circle_outline)
                  ],
                )),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey[50],
              thickness: 3,
              indent: 0,
              endIndent: 0,
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
              width: innerContainerWidth,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),

              //color: Colors.blue,
              child: Column(
                children: [
                  TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    controller: articleUrlController,
                    decoration: InputDecoration(
                      labelText: 'Article URL',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.add_link_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                  onPressed: () {
                    ServerHandler().postArticle(
                        _vinService.myVariable, articleUrlController.text);
                    articleUrlController.text = "";
                    _vinService.newArticleUrl = "";
                    FocusScope.of(context).unfocus();
                  },
                  icon: Icon(Icons.upload, size: 22),
                  label: Text("Upload"),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(new TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                      minimumSize: MaterialStateProperty.all(Size(100, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red))))),
            )
          ],
        ));
  }
}
