import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class LoadAction {
  const LoadAction();
}

enum PersonUrl { person1, person2 }

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl personUrl;
  const LoadPersonAction(this.personUrl);
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return "http://192.168.1.3:5500/lib/api/person1.json";
      case PersonUrl.person2:
        return "http://192.168.1.3:5500/lib/api/person2.json";
    }
  }
}


// add [] to iterable
extension Subscribt<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class PersonModel {
  final String name;
  final int age;

  PersonModel(this.name, this.age);
  PersonModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<List<PersonModel>> fetchPersonData(String url) async {
  // return await HttpClient()
  //     .getUrl(Uri.parse(url))
  //     .then((req) => req.close())
  //     .then((resp) => resp.transform(utf8.decoder).join())
  //     .then((str) => json.decode(str) as List<dynamic>)
  //     .then((value) => value.map((e) => PersonModel.fromJson(e)).toList());
  final Dio _dio=Dio();
  var resp= await _dio.get(url);
  if(resp.statusCode==200){
    List<PersonModel> data= (resp.data as List<dynamic>).map((e) => PersonModel.fromJson(e)).toList();
    return data;
  }
return <PersonModel>[];
}

class FetchResultState {
  final Iterable<PersonModel> persons;
  final bool isRetrievedFromCashe;
  const FetchResultState(this.isRetrievedFromCashe, this.persons);
  @override
  String toString() {
    return "FetchResultState(isRetrievedFromCashe=$isRetrievedFromCashe,persons=$persons)";
  }
}

class PersonBloc extends Bloc<LoadAction, FetchResultState?> {
  final Map<PersonUrl, Iterable<PersonModel>> _cashe = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      print("load action");
      final PersonUrl url = event.personUrl;
      if (_cashe.containsKey(url)) {
        print("fffffffff55");

        // get  data from cashe
        final FetchResultState result = FetchResultState(true, _cashe[url]!);
        emit(result);
      } else {

        print("ffffffffff6");
        final List<PersonModel> fetchedResult =
            await fetchPersonData(url.urlString) as List<PersonModel>;
        _cashe[url] = fetchedResult;
        print("what");
         print(fetchedResult[0].name);

        emit(FetchResultState(false, fetchedResult));
      }
    });
  }
}

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  context
                      .read<PersonBloc>()
                      .add(const LoadPersonAction(PersonUrl.person1));
                },
                child: const Text("Get Person 1")),
            TextButton(
                onPressed: () {
                  context
                      .read<PersonBloc>()
                      .add(const LoadPersonAction(PersonUrl.person2));
                },
                child: const Text("Get Person 2"))
          ],
        ),
        BlocBuilder<PersonBloc, FetchResultState?>(
          buildWhen: ((previous, current) {
            return previous?.persons != current?.persons ? true : false;
          }),
          builder: (context, state) {
            final persons = state?.persons;
            if (persons == null) {
              return const    Text("empty");
            } else {
              return Expanded(
                  child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: ((context, index) {
                        return ListTile(title: Text(persons[index]!.name));
                      }
                      )
                      )
                      );
            }
          },
        )
      ]),
    );
  }
}
