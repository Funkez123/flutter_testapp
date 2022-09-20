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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: const [
          TextField(
 decoration: const InputDecoration(
    border: UnderlineInputBorder(),
    labelText: 'Enter your username',)

          )
        ],



      ),
    );
  }
}