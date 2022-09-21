import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class NewArticlePage extends StatefulWidget {
  const NewArticlePage({super.key});

  @override
  State<NewArticlePage> createState() => NewArticlePageState();
}

final TextEditingController _title = TextEditingController();
final TextEditingController _shortdesc = TextEditingController();
final TextEditingController _desc = TextEditingController();
final TextEditingController _imgurl = TextEditingController();
final TextEditingController _text = TextEditingController();

final id = 11;

class Article {
  final int id;
  final String title;
  final String shortdesc;
  final String longdesc;
  final String text;
  final String imgurl;

  Article(this.id, this.title, this.shortdesc, this.longdesc, this.text,
      this.imgurl);


  Map toJson() => {
    'id': id,
    'title': title,
    "description_short": shortdesc,
    "description": longdesc,
    "text": text,
    "imageURL": imgurl,
      };
   
}

void updateJson() async{

  List articles  = await getJson();

  Article new_article = Article(id, _title.text, _shortdesc.text, _desc.text, _text.text, _imgurl.text);

  articles.add(new_article);

  String jsonTags = jsonEncode(articles);
  print(jsonTags);

  writeCounter(jsonTags);
  print("written");
  
  return;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/DemoData.json');
}

Future<File> writeCounter(String jsondata) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString(jsondata);
}

  Future<List> getJson() async {
    var data = await rootBundle.loadString('DemoData.json');
    var jsondata = await jsonDecode(data);

    List<Article> articles = [];

    for (var i in jsondata) {
      Article article = Article(i["id"], i["title"], i["description_short"],
          i["description"], i["text"], i["imageURL"]);

      articles.add(article);
    }

    return articles;
  }

class NewArticlePageState extends State<NewArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          const Card(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Neuen Artikel erstellen",
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
            )),
          )),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Artikelname',
              )),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Kurzbeschreibung',
              )),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Beschreibung',
              )),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Artikelinhalt',
              )),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration:  InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Inhalt',
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
              child: TextButton(
                  style : TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () async{

                    updateJson();

                  }, child: const Text("Artikel veröffentlichen",style: TextStyle(color: Colors.white))))
        ]),
      ),
    );
  }
}
