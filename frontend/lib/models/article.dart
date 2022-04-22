class Article {
  int id = 0;
  String vin = "";
  String title = "";
  String text = "";
  String articleUrl = "";
  DateTime created = DateTime.now();
  String language = "";

  Article.fromMap(Map<dynamic, dynamic> map) {
    this.id = map["id"];
    this.vin = map["vin"];
    this.title = map["title"];
    this.text = map["text"];
    this.articleUrl = map["articleUrl"];
    this.created = DateTime.parse(map["created"]);
    this.language = map["language"];
  }

  Article();
}
