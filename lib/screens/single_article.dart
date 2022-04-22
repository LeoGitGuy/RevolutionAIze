import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import '../services/article_service.dart';
import '../models/article.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/audio_manager.dart';

class SingleArticle extends StatefulWidget {
  SingleArticle({Key? key, required this.pgCont}) : super(key: key);
  final VoidCallback pgCont;

  @override
  _SingleArticleState createState() => _SingleArticleState();
}

class _SingleArticleState extends State<SingleArticle> {
  ArticleService _vinService = ArticleService();
  late final AudioManager _audioManager;
  var currentArticle = new Article();
  @override
  void initState() {
    super.initState();
    currentArticle = _vinService.myArticle;

    print("Init State: ${currentArticle.id}");
    _audioManager = AudioManager(currentArticle.id);
  }

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    double innerContainerWidth = MediaQuery.of(context).size.width - 100;
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    widget.pgCont();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    currentArticle.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Uploaded: " +
                      DateFormat("dd/MM hh:mm").format(currentArticle.created),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                ),
                Text("Language: ${currentArticle.language}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.white,
              thickness: 3,
              indent: 0,
              endIndent: 0,
            ),
            SizedBox(
              height: 10,
            ),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _audioManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  onSeek: _audioManager.seek,
                  baseBarColor: Color(0xFF0029FF),
                  thumbColor: Colors.red,
                  progressBarColor: Colors.black,
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                );
              },
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _audioManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: CircularProgressIndicator(
                        color: Color(0xFF0029FF),
                      ),
                    );
                  case ButtonState.paused:
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF0029FF), width: 4),
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Colors.green,
                        iconSize: 32.0,
                        onPressed: _audioManager.play,
                      ),
                    );
                  case ButtonState.playing:
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF0029FF), width: 4),
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.pause),
                        color: Colors.red,
                        iconSize: 32.0,
                        onPressed: _audioManager.pause,
                      ),
                    );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.white,
              thickness: 3,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(currentArticle.text,
                        style: GoogleFonts.andada(fontSize: 16)),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 3,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("URL: " + currentArticle.articleUrl)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
