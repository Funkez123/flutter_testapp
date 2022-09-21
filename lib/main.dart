import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onboarding/page-two.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'favpage.dart';
import 'package:onboarding/newarticle.dart';

Future<void> main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
      backgroundColor: Colors.blueGrey[100],
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Text(
              'Onboarding App',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('Overview'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Favoriten'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const favpage()));
            },
          ),
          ListTile(
            title: const Text('Artikel erstellen'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewArticlePage()));
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const secondpage()));
            },
          ),
        ],
      )),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(widget.title),
      ),
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
                                      hero_id: "img${snapshot.data[index].id}",
                                    )));
                      },
                      child: Card(
                          color: Colors.white,
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
                                          ImageChunkEvent? loadingProgress) {
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

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.text,
      required this.imgurl,
      required this.hero_id});

  final String title;
  final String description;
  final String text;
  final String imgurl;
  final String hero_id;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Hero(
                  tag: hero_id,
                  child: Image.network(
                    imgurl,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ))),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                  alignment: const Alignment(-1, 0),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 38, fontWeight: FontWeight.bold))),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: Divider(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(description,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300))),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Divider(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.normal))),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                Hive.initFlutter();
                var favbox = await Hive.openBox('favBox');
                if (favbox.containsKey("favorites") != true) {
                  List<int> emptylist = [];
                  await favbox.put("favorites", emptylist);
                }
                var fav_array = await favbox.get("favorites");
                if (fav_array.contains(id) == false) {
                  await fav_array.add(id);
                } else {
                  await fav_array.remove(id);
                }
                await favbox.put("favorites", fav_array);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Gefällt mir"), Icon(Icons.favorite)],
              ),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final url = Uri.parse(imgurl);
          final response = await http.get(url);
          final bytes = response.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';
          File(path).writeAsBytesSync(bytes);

          await Share.shareFiles([path], text: title);

          // Add your onPressed code here!
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.share),
      ),
    );
  }
}
