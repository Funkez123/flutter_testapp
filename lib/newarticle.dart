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
        child: ListView(

          children: const [

              Card(
                child: Center(child: Text("Artikel erstellen"))

              ),

              Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
           decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Artikelname',)
              ),
            ),
          ),]
        ),
      ),
    );
  }
}