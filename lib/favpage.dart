import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main.dart';

class favpage extends StatefulWidget {
  const favpage(
    {super.key,});

  @override
  State<favpage> createState() => _favpageState();
}

var boxlength = 0;
late var articles;
late List future_fav_array;

Future<List> getJson() async {

    Hive.initFlutter();
    var favbox = await Hive.openBox('favBox');
    boxlength = favbox.get("favorites").length;
    List fav_array = favbox.get("favorites");
    future_fav_array = fav_array;

    var data = await rootBundle.loadString('DemoData.json');
    var jsondata = await jsonDecode(data);

    List<Article> articles = [];


    for(var x=0; x<boxlength; x++){

      Article article = Article(jsondata[fav_array[x]-1]["id"], jsondata[fav_array[x]-1]["title"], jsondata[fav_array[x]-1]["description_short"],jsondata[fav_array[x]-1]["description"], jsondata[fav_array[x]-1]["text"], jsondata[fav_array[x]-1]["imageURL"]);

      articles.add(article);
    }

    return articles;
  }

  Future<List> getFavId() async{

    Hive.initFlutter();
    var favbox = await Hive.openBox('favBox');
    boxlength = favbox.get("favorites").length;
    List fav_array = favbox.get("favorites");
    future_fav_array = fav_array;
    return fav_array;
    
  }

class _favpageState extends State<favpage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
              future: getJson(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: Text("Loading"));
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                          id: snapshot.data[index].id,
                                          title: snapshot.data[index].title,
                                          description:
                                              snapshot.data[index].longdesc,
                                          text: snapshot.data[index].text,
                                          imgurl: snapshot.data[index].imgurl,
                                          hero_id:
                                              "img${snapshot.data[index].id}",
                                        )));
                          },
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                Hero(
                                    tag: "img${snapshot.data[index].id}",
                                    child: Image.network(
                                      snapshot.data[index].imgurl,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent?
                                              loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    )),
                                Align(
                                    alignment: const Alignment(-1, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[index].title,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                const Divider(
                                  thickness: 1,
                                ),
                                Align(
                                    alignment: const Alignment(-1, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[index].shortdesc,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    )),
                                  ],
                                ),
                              )),
                        );
                      });
                }
              }),
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