import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;

void main() async{
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  
  Future<List> getJson() async{
    var data = await rootBundle.loadString('DemoData.json');
    var jsondata =  await jsonDecode(data);  
    
  List<Card> cards = [];

  for (var i in jsondata){
    Card card = Card(i["id"],i["title"],i["description_short"],i["description"],i["text"],i["imageURL"]);

    cards.add(card);
  }

    print(cards.length);
    return cards;
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
          color: Colors.blue,
        ),
        child: Text('Drawer Header'),
      ),

      ListTile(
        title: const Text('Overview'),
        onTap: () {
          // Update the state of the app.
          // ...
          
        },
      ),

      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
          ],
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
      ),
      body: Container(

            child: FutureBuilder(
              future: getJson(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                if(snapshot.data == null){
                  return Container(
                    child: Center(child: Text("Loading"))
                  );
                }
                else {
             
             return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                return ListTile(
                  title: Text(snapshot.data[index].title),
                );

              }

            );
              }
              }
          )

      ),
        );
  }
}


class Card {
  final int id;
  final String title;
  final String shortdesc;
  final String longdesc;
  final String text;
  final String imgurl;

  Card(this.id, this.title, this.shortdesc, this.longdesc, this.text, this.imgurl);

}