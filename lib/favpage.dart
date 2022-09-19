import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class favpage extends StatefulWidget {
  const favpage(
    {super.key,});

  @override
  State<favpage> createState() => _favpageState();
}

late var boxlength = 0;
late var articles;

  Future<List> getJsonAndBoxes() async {
      Hive.initFlutter();
      var favbox = await Hive.openBox('favBox');
      boxlength = favbox.get("favorites").length;

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

  Future<List> getFavId() async{

    Hive.initFlutter();
    
    var favbox = await Hive.openBox('favBox');
    List fav_array = favbox.get("favorites");

    return fav_array;
    
  }

class _favpageState extends State<favpage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
        future: getJsonAndBoxes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          articles = getJsonAndBoxes();
          return ListView.builder(itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("you pressed ${index}");
            },
            child: Card(
              child: Container(
                child: FutureBuilder(
                  future: getFavId(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    
                    if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading")));
                } else {
                    
                     
                     return Container(
                  color: Colors.white,
                  child: Center(child:Text(articles.toString())),
                );}}),
                height: 200),
            )
          );
          },
      
          itemCount: boxlength,
        ); },
        
      ),
    );
  }
}

class Article {
  final int id;
  final String title;
  final String shortdesc;
  final String longdesc;
  final String text;
  final String imgurl;

  Article(this.id, this.title, this.shortdesc, this.longdesc, this.text,
      this.imgurl);
}