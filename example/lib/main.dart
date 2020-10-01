import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'SearchAppBarPage',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

abstract class Routes {
  static const HOME = '/home';
  static const PAGE_1 = '/page-1';
  static const PAGE_2 = '/page-2';
  static const PAGE_3 = '/page-3';
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.PAGE_1, page: () => SearchAppBarStream()),
    GetPage(name: Routes.PAGE_2, page: () => SearchPage()),
    GetPage(name: Routes.PAGE_3, page: () => SearchPage()),
  ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_1);
                },
                child: Text(
                  'Ir para SearchStreamPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_2);
                },
                child: Text(
                  'Ir para SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
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

      /// Caso queira sort escolha como fazer
      compareSort: (Person a, Person b) => a.name.compareTo(b.name),
      filtersType: FiltersTypes.contains,
      listBuilder: (context, list, isModSearch) {
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

/*final dataStrings = [
    'Antonio Rabelo',
    'Raquel Lima',
    'Roberto Costa',
    'Alina Silva',
    'William Lima',
    'Flavio Assunção',
    'Zenilda Cardoso'
  ];*/
}

// ignore: must_be_immutable
class SearchAppBarFuturePagination extends StatefulWidget {
  const SearchAppBarFuturePagination({Key key}) : super(key: key);

  @override
  _SearchAppBarFuturePaginationState createState() =>
      _SearchAppBarFuturePaginationState();
}

class _SearchAppBarFuturePaginationState
    extends State<SearchAppBarFuturePagination> {
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
    return SearchAppBarPageFuturePagination<Person>(
        //initialData: _initialData,
        magnifyinGlassColor: Colors.white,
        searchAppBarcenterTitle: true,
        searchAppBarhintText: 'Pesquise um Nome',
        searchAppBartitle: Text(
          'Search Stream Page',
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
                padding: const EdgeInsets.all(14.0),
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

  Future<List<Person>> _futureListPerson(int page, String query) async {
    final size = 8;
    List<Person> list = [];

    final fistElement = (page - 1) * size;
    final lastElement = page * size;

    int totalPages = (dataListPerson3.length / size).ceil();
    totalPages = totalPages == 0 ? 1 : totalPages;

    await Future<void>.delayed(Duration(seconds: 6));

    if (query.isEmpty) {
      list = dataListPerson3.sublist(
          fistElement,
          lastElement > dataListPerson3.length
              ? dataListPerson3.length
              : lastElement);
    } else {
      list = dataListPerson3
          .where((element) => contains(element, query))
          .toList()
          .sublist(
              fistElement,
              lastElement > dataListPerson3.length
                  ? dataListPerson3.length
                  : lastElement);
      ;
    }

    return list;
  }

  static bool Function(Person person, String query) contains =
      (Person test, query) {
    final realTest = _prepareString(test.name);
    final realQuery = _prepareString(query);
    return realTest.contains(realQuery);
  };

  static String _prepareString(String string) =>
      removeDiacritics(string).toLowerCase();
}

// ignore: must_be_immutable
class SearchAppBarStream extends StatefulWidget {
  const SearchAppBarStream({Key key}) : super(key: key);

  @override
  _SearchAppBarStreamState createState() => _SearchAppBarStreamState();
}

class _SearchAppBarStreamState extends State<SearchAppBarStream> {
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
    return SearchAppBarPageStream<Person>(
      //initialData: _initialData,
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
      listBuilder: (context, list, isModSearch) {
        // Rertorne seu widget com a lista para o body da page
        // Pode alterar a tela relacionando o tipo de procura
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
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
              ),
            ),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_2);
                },
                child: Text(
                  'Ir para SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  'SetState',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        );
      },
    );
  }

  Stream<List<Person>> _streamListPerson = (() async* {
    await Future<void>.delayed(Duration(seconds: 15));
    yield dataListPerson;
    await Future<void>.delayed(Duration(seconds: 8));
    yield dataListPerson2;
    await Future<void>.delayed(Duration(seconds: 6));
    yield dataListPerson3;
  })();
}

final dataListPerson0 = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
];

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

final dataListPerson3 = <Person>[
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
  Person(name: 'Thiago Ferreira', age: 33),
  Person(name: 'Joaquim Gomes', age: 18),
  Person(name: 'Esther Guerra', age: 23),
  Person(name: 'Pedro Braga', age: 19),
  Person(name: 'Milu Silva', age: 33),
  Person(name: 'William Ristow', age: 47),
  Person(name: 'Elias Tato', age: 19),
  Person(name: 'Dada Istomesmo', age: 15),
  Person(name: 'Nome Incomum', age: 33),
];

class Person {
  final String name;

  final int age;

  Person({this.name, this.age});
}
