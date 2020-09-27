# search_app_bar_page 

A Flutter package to give you a simple search page.

#### Translation [Em Português](docs/README.pt.md )

## Introduction

This package was built to generate a complete and reactive search screen with the best possible facility.
It is based on another package. Would you like 👀 the animation when triggering the search? Open here [search_app_bar] (https://pub.dev/packages/search_app_bar)
(by - rodolfoggp@gmail.com). There you have the details of the search_app_bar functions. With the changes here,
you will not need to extend the controller class but just pass the base list to be filtered or insert
the stream that returns your list to be filtered. In this case, there is already a StreamBuilder to do the
background treatment. Unfortunately, I was unable to update the base package, as Rodolfo has not changed the package for more 
than 01 year and has not responded to my change request by email.

##### ✷ The page is divided between 
- SEARCH_APP_BAR 
- CONTROLLER
- BODY de um Scaffold.

## Required parameters

![](lib/img/example_video.mp4)

Temos duas páginas: <blockquote> SearchAppBarPage e SearchAppBarPageStream.</blockquote>

🔎 SearchAppBarPage needs a list that is the complete list to be filtered and a function that is passed on to build
the Widget depending on the filtered list. If you type the page, you need [stringFilter]. This is a function that receives 
the parameter T (type of list) and you choose it as the Return String from the object. As in the example below. It was typed
as Person and returned person.name. This will be used to filter by the search query. 

```dart
SearchAppBarPage({ 
       Key key,
       /// Parametros para o SearcherGetController
       @required this.listFull, 
       @required this.listBuilder,
       this. StringFilter,   /// Required if you type. 
       ///If not, it is understood that the type will be String. 
             ...
```

🔎 SearchAppBarPageStream needs a stream that is already worked on, that is, there is already a Widget by default 
for error and waiting. You can modify them at will. You also need a function that is passed on to assemble the Widget 
that will be presented on the Body, depending on the filtered list. This is renewed by the natural flow of the stream 
and also by the search filtering. 

```dart 
SearchAppBarPageStream({
    Key key,
    /// Parametros para o SearcherGetController
    @required this.listStream, /// final Stream<List<T>> listStream;
    @required this.listBuilder,
             ...
```

## Example 
###### Vide [Example](https://pub.dev/packages/search_app_bar_page/example) for more details.
#### 🔎 SearchAppBarPage

```dart
import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

class SearchPage extends StatelessWidget {
  /*final dataStrings = [
    'Antonio Rabelo',
    'Raquel Lima',
    'Roberto Costa',
    'Alina Silva',
    'William Lima',
    'Flavio Assunção',
    'Zenilda Cardoso'
  ];*/

  @override
  Widget build(BuildContext context) {
    //return SearchAppBarPage<String>(
    return SearchAppBarPage<Person>(
      searchAppBariconTheme:
          Theme.of(context).iconTheme.copyWith(color: Colors.white),
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'Pesquise um Nome',
      searchAppBartitle: Text(
        'Search Page',
        style: TextStyle(fontSize: 20),
      ),
      //listFull: dataList, // Lista String
      listFull: dataListPerson2,
      stringFilter: (Person person) => person.name,
      compareSort: (Person a, Person b) => a.name.compareTo(b.name),
      filtersType: FiltersTypes.contains,
      listBuilder: (list, isModSearch) {
        // Rertorne seu widget com a lista para o body da page
        // Pode alterar a tela relacionando o tipo de procura
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                // color: Theme.of(context).primaryColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Name: ${list[index].name}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Age: ${list[index].age.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  final dataListPerson2 = <Person>[
    Person(name: 'Rafaela Pinho', age: 30),
    Person(name: 'Paulo Emilio Silva', age: 45),
    Person(name: 'Pedro Gomes', age: 18),
    Person(name: 'Orlando Guerra', age: 23),
    Person(name: 'Zacarias Triste', age: 15),
    Person(name: 'Antonio Rabelo', age: 33),
    Person(name: 'Leticia Maciel', age: 47),
    Person(name: 'Patricia Oliveira', age: 19),
    Person(name: 'Pedro Lima', age: 15),
    Person(name: 'Junior Rabelo', age: 33),
    Person(name: 'Lucia Maciel', age: 47),
    Person(name: 'Ana Oliveira', age: 19),
    Person(name: 'Thiago Silva', age: 33),
    Person(name: 'Charles Ristow', age: 47),
    Person(name: 'Raquel Montenegro', age: 19),
    Person(name: 'Rafael Peireira', age: 15),
    Person(name: 'Nome Comum', age: 33),
  ];
}

class Person {
  final String name;

  final int age;

  Person({this.name, this.age});
}

```
#### 🔎 SearchAppBarPageStream
```dart
import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

// ignore: must_be_immutable
class SearchAppBarStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchAppBarPageStream<Person>(
      searchAppBariconTheme:
          Theme.of(context).iconTheme.copyWith(color: Colors.white),
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'Pesquise um Nome',
      searchAppBartitle: Text(
        'Search Stream Page',
        style: TextStyle(fontSize: 20),
      ),
      listStream: _streamListPerson,
      stringFilter: (Person person) => person.name,
      compareSort: (Person a, Person b) => a.name.compareTo(b.name),
      filtersType: FiltersTypes.contains,
      listBuilder: (list, isModSearch) {
        // Rertorne seu widget com a lista para o body da page
        // Pode alterar a tela relacionando o tipo de procura
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                // color: Theme.of(context).primaryColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Name: ${list[index].name}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Age: ${list[index].age.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  Stream<List<Person>> _streamListPerson = (() async* {
    await Future<void>.delayed(Duration(seconds: 5));
    yield dataListPerson;
    await Future<void>.delayed(Duration(seconds: 10));
    yield dataListPerson2;
  })();
}

final dataListPerson = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
];

final dataListPerson2 = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
  Person(name: 'Antonio Rabelo', age: 33),
  Person(name: 'Leticia Maciel', age: 47),
  Person(name: 'Patricia Oliveira', age: 19),
  Person(name: 'Pedro Lima', age: 15),
  Person(name: 'Junior Rabelo', age: 33),
  Person(name: 'Lucia Maciel', age: 47),
  Person(name: 'Ana Oliveira', age: 19),
  Person(name: 'Thiago Silva', age: 33),
  Person(name: 'Charles Ristow', age: 47),
  Person(name: 'Raquel Montenegro', age: 19),
  Person(name: 'Rafael Peireira', age: 15),
  Person(name: 'Nome Comum', age: 33),
];

class Person {
  final String name;

  final int age;

  Person({this.name, this.age});
}

```

## Filters

These are the filters that the Controller uses to filter the list. Divide the filters into three types: 

```enum FiltersTypes { startsWith, equals, contains }```

Default = FiltersTypes.contains;

## Search_app_bar parameters

Here [search_app_bar parameters] (https://pub.dev/packages/search_app_bar#parameters),
in the base package, you can understand each component.
<blockquote> NEW Components </blockquote>

`` `[iconConnectyOffAppBar]` `` Appears when the connection status is off. There is already a default icon. If you don't want to present a choice
`` `[showIconConnectyOffAppBar]` `` = false;

`` `[widgetConnecty]` `` Only shows something when it is disconnected and does not yet have the first value of the stream. If the connection goes back to show the
`` `[widgetWaiting]` `` until you receive the first data. Everyone already comes with They all come with default widgets.


## Disclaimer

The initial design of this package has an animation provided in a tutorial by Nishant Desai
at: https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

All merits for Rodolfo (rodolfoggp@gmail.com) and Nishant Desai.

       


