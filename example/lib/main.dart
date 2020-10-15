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
    GetPage(name: Routes.PAGE_3, page: () => SearchAppBarPaginationTest()),
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
                  Get.toNamed(Routes.PAGE_2);
                },
                child: Text(
                  'Go to the SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_1);
                },
                child: Text(
                  'Go to the SearchStreamPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_3);
                },
                child: Text(
                  'Go to the SearchAppBarPagination',
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
      searchAppBarhintText: 'Search for a name',
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
        if (list.isEmpty) {
          return Center(
              child: Text(
            'NOTHING FOUND',
            style: TextStyle(fontSize: 14),
          ));
        }
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
}

// ignore: must_be_immutable
class SearchAppBarStream extends StatefulWidget {
  const SearchAppBarStream({Key key}) : super(key: key);

  @override
  _SearchAppBarStreamState createState() => _SearchAppBarStreamState();
}

class _SearchAppBarStreamState extends State<SearchAppBarStream> {
  @override
  Widget build(BuildContext context) {
    return SearchAppBarPageStream<Person>(
      //initialData: _initialData,
      magnifyinGlassColor: Colors.white,
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'Search for a name',
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
        if (list.isEmpty) {
          return Center(
              child: Text(
            'NOTHING FOUND',
            style: TextStyle(fontSize: 14),
          ));
        }
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

  //Please work your stream to not return null.
  Stream<List<Person>> _streamListPerson = (() async* {
    await Future<void>.delayed(Duration(seconds: 3));
    //yield null;
    yield dataListPerson;
    await Future<void>.delayed(Duration(seconds: 4));
    yield dataListPerson2;
    await Future<void>.delayed(Duration(seconds: 5));
    //throw Exception('Erro voluntario');
    yield dataListPerson3;
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

// ignore: must_be_immutable
class SearchAppBarPaginationTest extends StatefulWidget {
  const SearchAppBarPaginationTest({Key key}) : super(key: key);

  @override
  _SearchAppBarPaginationTestState createState() =>
      _SearchAppBarPaginationTestState();
}

class _SearchAppBarPaginationTestState
    extends State<SearchAppBarPaginationTest> {
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

  ///Example of server side function. Return the list in parts or parts by
  ///query String. We make the necessary changes on the device side to update
  ///the page to be requested. Ex.: If numItemsPage = 6 and you receive
  ///05 or 11 or send empty, = >>> it means that the data is over.
  //Please work your future to not return null.
  Future<List<Person>> _futureListPerson(int page, String query) async {
    final size = 15;
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

    //return null;

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

    //throw Exception('Voluntary Error');
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

final dataListPerson3 = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Ana Pereira', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
  Person(name: 'Antonio Rabelo', age: 33),
  Person(name: 'Leticia Maciel', age: 47),
  Person(name: 'Patricia Oliveira', age: 19),
  Person(name: 'Pedro Lima', age: 15),
  Person(name: 'Fabio Melo', age: 51),
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
  Person(name: 'Milu Silva', age: 17),
  Person(name: 'William Ristow', age: 47),
  Person(name: 'Elias Tato', age: 22),
  Person(name: 'Dada Istomesmo', age: 44),
  Person(name: 'Nome Incomum', age: 52),
  Person(name: 'Qualquer Nome', age: 9),
  Person(name: 'First Last', age: 11),
  Person(name: 'Bom Dia', age: 23),
  Person(name: 'Bem Mequiz', age: 13),
  Person(name: 'Mal Mequer', age: 71),
  Person(name: 'Quem Sabe', age: 35),
  Person(name: 'Miriam Leitao', age: 33),
  Person(name: 'Gabriel Mentiroso', age: 19),
  Person(name: 'Caio Petro', age: 27),
  Person(name: 'Tanto Nome', age: 66),
  Person(name: 'Nao Diga', age: 33),
  Person(name: 'Fique Queto', age: 11),
  Person(name: 'Cicero Gome', age: 37),
  Person(name: 'Carlos Gome', age: 48),
  Person(name: 'Mae Querida', age: 45),
  Person(name: 'Exausto Nome', age: 81),
];

//class Person extends CacheJson {
class Person {
  final String name;

  final int age;

  Person({this.name, this.age});

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }

/* @override
   CacheJson fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
    };
  }*/
}
