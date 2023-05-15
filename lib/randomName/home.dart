import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:learnbloc/randomName/name_bloc.dart';
class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NameBloc nameBloc;
  final Button=TextButton(onPressed: (){
    
  }, child: const Text("Pick"));

@override
void initState() {
    super.initState();
    nameBloc=NameBloc();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: nameBloc.stream,
        builder: (context,snapshot){
          switch(snapshot.connectionState)
          {
            case ConnectionState.none:
            return Button;
            
            case ConnectionState.waiting:
              return Button;
            case ConnectionState.active:
             return Column(
               children: [
                 Text(snapshot.data.toString() ??""),
                Button

               ],
             );
            case ConnectionState.done:
              return Button;
              break;
          }
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nameBloc.pickRnadomNmae();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


