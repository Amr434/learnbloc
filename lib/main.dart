import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnbloc/person_page.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  print("any");
  await fetchPersonData('http://192.168.1.3:5500/lib/api/person1.json').then((value) {

    print(value[0].name);
  }).catchError((e){
    if(e is DioError){
      print(e.error);
    }
    print(e);
  });
 // await fetchPersonData('http://10.0.0.2:5500/lib/api/person2.json').then((value) {
 //   print("fg");
 //    print(value.toString());
 //  }).catchError((e){
 //    print(e);
 // });
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
          create: (context) => PersonBloc(), child: const PersonPage()),
    );
  }
}
