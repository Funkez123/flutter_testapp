import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onboarding/page-two.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

void main() async {
  var favbox = Hive.box('favBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Onboarding App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List data;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Overview'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => secondpage()));
            },
          ),
        ],
      )),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
      ),
      body: Container(
          child: FutureBuilder(
              future: getJson(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading")));
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
                                          title: snapshot.data[index].title,
                                          description:
                                              snapshot.data[index].longdesc,
                                          imgurl: snapshot.data[index].imgurl,
                                          hero_id:
                                              "img${snapshot.data[index].id}",
                                        )));
                          },
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    child: Column(
                                  children: [
                                    Hero(
                                        tag: "img${snapshot.data[index].id}",
                                        child: Image.network(
                                            snapshot.data[index].imgurl)),
                                    Align(
                                        alignment: Alignment(-1, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data[index].title,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Align(
                                        alignment: Alignment(-1, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data[index].shortdesc,
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        )),
                                  ],
                                )),
                              )),
                        );
                      });
                }
              })),
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

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required this.title,
      required this.description,
      required this.imgurl,
      required this.hero_id});

  final String title;
  final String description;
  final String imgurl;
  final String hero_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Hero(tag: hero_id, child: Image.network(imgurl)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
                alignment: Alignment(-1, 0),
                child: Text(title,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(description, style: TextStyle(fontSize: 18)))
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          final url = Uri.parse(imgurl);
          final response = await http.get(url);  
          final bytes = response.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';
          File(path).writeAsBytesSync(bytes);

          await Share.shareFiles([path], text: title);

          // Add your onPressed code here!
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.share),
      ),
      
    );
  }
}
