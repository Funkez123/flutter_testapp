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
                  onPressed: () {}, child: const Text("Artikel veröffentlichen",style: TextStyle(color: Colors.white))))
        ]),
      ),
    );
  }
}
