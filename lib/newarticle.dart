import 'package:flutter/material.dart';

class NewArticlePage extends StatefulWidget {
  const NewArticlePage({super.key});

  @override
  State<NewArticlePage> createState() => NewArticlePageState();
}

class NewArticlePageState extends State<NewArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: const [
          Card(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Neuen Artikel erstellen",
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
            )),
          )),
          Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Artikelname',
              )),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Kurzbeschreibung',
              )),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Beschreibung',
              )),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Artikelinhalt',
              )),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Inhalt',
              )),
            ),
          ),
        ]),
      ),
    );
  }
}
