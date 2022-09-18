import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class favpage extends StatefulWidget {
  const favpage(
    {super.key,});

  @override
  State<favpage> createState() => _favpageState();
}

late var boxlength = 0;

Future<void> getFav() async{
  var favbox = await Hive.openBox('favBox');
  boxlength = favbox.length;
}


class _favpageState extends State<favpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
        future: getFav(),
        
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) { return ListView.builder(itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("you pressed ${index}");
            },
            child: Card(
              child: Container(
                
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

