# search_app_bar_page 

A Flutter package to give you a simple search page.

#### Translation [Em Português](doc/README.pt.md )

## Introduction

This package was built to generate a complete and reactive search screen with the best possible facility.
It is based on another package. Open here = > [search_app_bar](https://pub.dev/packages/search_app_bar) (by - rodolfoggp@gmail.com). There you have the details of the search_app_bar functions. With the changes here,
you do not need to extend the controller class, but just pass the base list to be filtered or insert
the stream that returns your list to be filtered. In this case, there is already a StreamBuilder to do the
background treatment. Unfortunately, I was unable to update the basic package, as Rodolfo has not handled the package 
for more than 01 year and has not responded to my request for changes by email.

![example_video](https://user-images.githubusercontent.com/41010018/94386509-426cb800-011e-11eb-975d-05bd57707b16.gif)


##### ✷ The page is divided between 
- SEARCH_APP_BAR 
- CONTROLLER
- BODY de um Scaffold.

## Required parameters

We have three pages: <blockquote> SearchAppBarPage, SearchAppBarPageStream and  SearchAppBarPagination</blockquote>

🔎 <span> </span> ```SearchAppBarPage``` needs a list that is the complete list to be filtered and a function that is passed on to build
the Widget depending on the filtered list. If you type the page, you need [stringFilter]. This is a function that receives 
the parameter T (type of list) and you choose it as the Return String from the object. As in the example below. It was typed
as Person and returned person.name. This will be used to filter by the search query. 

```dart
class SearchAppBarPage<T> extends StatefulWidget {
          //...

SearchAppBarPage(
                       //...
       /// Parameters para o SearcherGetController
       /// final List<T> listFull;
       @required this.listFull, 
        /// [listBuilder] Function applied when it is filtering in search.
       @required this.listBuilder,
        /// [stringFilter] Required if you type. 
       ///You should at least type with String.
       this.stringFilter
                  //...
    )
}
```

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
      magnifyinGlassColor: Colors.white,
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

🔎 ```SearchAppBarPageStream``` needs a stream that is already worked on, that is, there is already a Widget by default 
for error and waiting. You can modify them at will. You also need a function that is passed on to assemble the Widget 
that will be presented on the Body, depending on the filtered list. This is renewed by the natural flow of the stream 
and also by the search filtering. 

```dart
class SearchAppBarPageStream<T> extends StatefulWidget {
      //...

SearchAppBarPageStream(
        //...
    /// final Stream<List<T>> listStream;
    @required this.listStream, 
    ///final FunctionList<T> listBuilder; 
    /// Function applied when receiving data through Stream or filtering in search.
    @required this.listBuilder,
    /// [stringFilter] Required if you type. 
       ///You should at least type with String.
    this.stringFilter
        // ...
   ) 
      //...
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
      magnifyinGlassColor: Colors.white,
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


🔎 <span> </span> ```SearchAppBarPagination``` is built for fragmented requests for your API. If you have hundreds of data and would like to send them in parts, in addition to being able to filter them efficiently, this Widget is the chosen one. There is a cache of requests to avoid getting (REST) unnecessarily. The cache Kis reset when a screen is disposed. What differs from StreamPage is that a function that forwards the page and the search string query will always be called when necessary. Example: reaches the bottom of the page. 
Remembering that this function must return a Future (get for your API). You will see an example with the server side below [in Dart](https://github.com/MarceloRab/search_app_bar_page#example-of-server-side-function).


```dart
class SearchAppBarPagination<T> extends StatefulWidget {
      //...

SearchAppBarPagination(
        //...
    ///Returns Widget from the object (<T>). This comes from the List <T> index.
    ///typedef WidgetsPaginationItemBuilder<T> = Widget Function(
    ///    BuildContext context, int index, T objectIndex);
    ///final WidgetsPaginationItemBuilder<T> paginationItemBuilder;
    @required this.paginationItemBuilder,
    ///Return the list in parts or parts by query String
    ///filtered. We make the necessary changes on the device side to update the
    ///page to be requested. Eg: If numItemsPage = 6 and you receive 05 or 11
    ///or send empty, = >>> it means that the data is over.
    ///typedef FutureFetchPageItems<T> = Future<List<T>> Function(int page, String query);       
    /// final FutureFetchPageItems<T> futureFetchPageItems;
    @required  this.futureFetchPageItems,

    /// [stringFilter] Required if you type. 
    ///You should at least type with String.
    this.stringFilter
        // ...
   ) 
      //...
}
```

##### 😱 You can make a setState on your stream page and your pagination or a rot Reload without any problems. Even changing the value of initialData.


#### 🔎 SearchAppBarPagination

```dart
class SearchAppBarPaginationTest extends StatefulWidget {
  const SearchAppBarPaginationTest({Key key}) : super(key: key);

  @override
  _SearchAppBarPaginationTestState createState() =>
      _SearchAppBarPaginationTestState();
}

class _SearchAppBarPaginationTestState
    extends State<SearchAppBarPaginationTest> {
  //var _initialData;

  /*@override
  void initState() {
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        _initialData = dataListPerson0;
      });
    });
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return SearchAppBarPagination<Person>(
        //initialData: _initialData,
        magnifyinGlassColor: Colors.white,
        searchAppBarcenterTitle: true,
        searchAppBarhintText: 'Pesquise um Nome',
        searchAppBartitle: Text(
          'Search Pagination',
          style: TextStyle(fontSize: 20),
        ),
        futureFetchPageItems: _futureListPerson,
        stringFilter: (Person person) => person.name,
        compareSort: (Person a, Person b) => a.name.compareTo(b.name),
        filtersType: FiltersTypes.contains,
        paginationItemBuilder:
            (BuildContext context, int index, Person objectIndex) {
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              // color: Theme.of(context).primaryColorDark,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 130.0, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Name: ${objectIndex.name}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Age: ${objectIndex.age.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
```

![WhatsApp-Video-2020-10-05-at-23 33](https://user-images.githubusercontent.com/41010018/95152485-8cc7e780-0763-11eb-9c77-55b3fe84fd61.gif)

#### Example of server side function.

Here in Dart. Return the list in parts or parts by query String filtered. We make the necessary changes on the device side to update the page to be requested. Eg: If numItemsPage = 6 and you receive 05 or 11 or send empty, = >>> it means that the data is over.

##### I had to spend a few hours testing it so there were no mistakes. Do tests and if you find an error, I would be happy to resolve them as soon as possible.

```dart
Future<List<Person>> _futureListPerson(int page, String query) async {
    final size = 8;
    List<Person> list = [];

    final fistElement = (page - 1) * size;
    final lastElement = page * size;

    /*print('fistElement = ' + fistElement.toString());
    print('lastElement = ' + lastElement.toString());
    print('--------');
    print('page pedida = ' + page.toString());
    print('--------');*/

    dataListPerson3.sort((a, b) => a.name.compareTo(b.name));

    await Future<void>.delayed(Duration(seconds: 3));

    if (query.isEmpty) {
      int totalPages = (dataListPerson3.length / size).ceil();
      totalPages = totalPages == 0 ? 1 : totalPages;

      //print('TotalPages = ' + totalPages.toString());
      if (page > totalPages) {
        //print('--TEM--nada');
        return list;
      }

      list = dataListPerson3.sublist(
          fistElement,
          lastElement > dataListPerson3.length
              ? dataListPerson3.length
              : lastElement);
      /*if (list.length < size) {
        print('-###-  Last  ---Page --- Full');
      }*/
    } else {
      final listQuery =
          dataListPerson3.where((element) => contains(element, query)).toList();
      ;

      int totalQueryPages = (listQuery.length / size).ceil();
      totalQueryPages = totalQueryPages == 0 ? 1 : totalQueryPages;

      //print('TotalQueryPages = ' + totalQueryPages.toString());

      if (page > totalQueryPages) {
        //print('--TEM---nada');
        return list;
      }

      list = listQuery.sublist(fistElement,
          lastElement > listQuery.length ? listQuery.length : lastElement);

      /*if (list.length < size) {
        print('-###-  LAst -- Page --- Search');
      }*/
    }

    return list;
  }

```

#### Vide [Example full](https://pub.dev/packages/search_app_bar_page/example) for more details.

## Filters

These are the filters that the Controller uses to filter
 the list. Divide the filters into three types: 

```enum FiltersTypes { startsWith, equals, contains }```

Default = FiltersTypes.contains;

## Search_app_bar parameters

Here [search_app_bar parameters] (https://pub.dev/packages/search_app_bar#parameters),
in the base package, you can understand each component.

<blockquote> NEW Components </blockquote>

## Reactivity to the connection.

`[iconConnectyOffAppBar]` Appears when the connection status is off. There is already a default icon. 
If you don't want to present a choice `[hideDefaultConnectyIconOffAppBar]` = true; If you want to have a custom icon,
do `[hideDefaultConnectyIconOffAppBar]` = true; and set the `[iconConnectyOffAppBar]`.

`[widgetOffConnectyWaiting]` Only shows something when it is disconnected and does not yet have the 
first value of the stream. If the connection goes back to show the `[widgetWaiting]` until you 
receive the first data. Everyone already comes with They all come with default widgets.

![20201007-203744-360x780](https://user-images.githubusercontent.com/41010018/95398660-c708c480-08dc-11eb-8b07-e0ffa816cbbc.gif)

## Disclaimer

The initial design of this package has an animation provided in a tutorial by Nishant Desai
at: https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

All merits for Rodolfo (rodolfoggp@gmail.com) and Nishant Desai.
