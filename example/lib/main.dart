//import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'SearchAppBarPage',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: MyBinddings(),
    ),
  );
}

class MyBinddings extends Bindings {
  @override
  void dependencies() {
    Get.put(TestController());
  }
}

abstract class Routes {
  static const HOME = '/home';
  static const PAGE_1 = '/page-1';
  static const PAGE_2 = '/page-2';
  static const PAGE_3 = '/page-3';
  static const PAGE_4 = '/page-4';
  static const PAGE_5 = '/page-5';
  static const PAGE_6 = '/page-6';
  static const PAGE_7 = '/page-7';
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.PAGE_1, page: () => SearchAppBarStream()),
    GetPage(name: Routes.PAGE_7, page: () => SearchAppBarRefresh()),
    GetPage(name: Routes.PAGE_2, page: () => SearchPage()),
    GetPage(name: Routes.PAGE_3, page: () => SearchAppBarPaginationTest()),
    GetPage(
        name: Routes.PAGE_4,
        page: () => SimpleAppBarPage(
              listFull: dataListPerson2,
              stringFilter: (Person person) => person.name,
            )),
    GetPage(
        name: Routes.PAGE_5,
        page: () {
          Get.put(Test2Controller());
          changeAuth();
          return TestGetStreamPage();
        }),
    GetPage(
        name: Routes.PAGE_6,
        page: () {
          Get.put(Test2Controller());
          changeAuth();
          return TestStreamWidget();
        }),
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
                  Get.toNamed(Routes.PAGE_7);
                },
                child: Text(
                  'Go to the SearchRefreshPage',
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
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_4);
                },
                child: Text(
                  'Go to the SimpleAppBar',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_5);
                },
                child: Text(
                  'Go to the StreamPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_6);
                },
                child: Text(
                  'Go to the StreamWidget',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}

class TestController extends GetxController {
  final rxAuth = false.obs;

  set changeAuth(bool value) => rxAuth.value = value;

  get isAuth => rxAuth.value;

  final rxList = <Person>[].obs;
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TestController controll_1;

  /// ## ✳️ Learning both ways to add reactive variables.
  @override
  void initState() {
    ///-------------------------------------------------------------------
    ///  Add other reactive parameters inside the body.
    /// ✅  Boot your controller into a StatefulWidget.
    ///-------------------------------------------------------------------
    controll_1 = Get.find<TestController>();
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      ///------------------------------------------
      /// Test to check the reactivity of the screen.
      /// Reactive variable as parameter - [rxBoolAuth]
      ///------------------------------------------
      /// 👇🏼
      controll_1.changeAuth = true;
    });

    Future.delayed(const Duration(seconds: 6), () {
      ///------------------------------------------
      /// Test to check the reactivity of the screen.
      ///
      /// Reactive variable as parameter within the function [obxListBuilder]
      ///------------------------------------------
      /// 👇🏼
      controll_1.rxList.refresh();
    });
  }

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
      //sortCompare: false,
      ///--------------------------------------------
      /// ✅ Add the auth reactive parameters.
      ///  The body will be rebuilt when the auth is false.
      ///---------------------------------------------
      rxBoolAuth: RxBoolAuth.input(
          rxBoolAuthm: Get.find<TestController>().rxAuth,
          authFalseWidget: () => Center(
                child: Text(
                  'Please login.',
                  style: TextStyle(fontSize: 22),
                ),
              )),
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive verables into it.

        ///----------------------------------------------------
        /// Changes to the rxList will also rebuild the widget.
        ///----------------------------------------------------

        print(' TEST -- ${controll_1.rxList.length.toString()} ');

        ///-------------------------------------------------------------
        /// Changes to the filtered list will also reconstruct the body.
        ///-------------------------------------------------------------

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
      //stringFilter: (Person person) => person.age.toString(),
      //sortCompare: false,
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive verables into it.
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

class SearchAppBarRefresh extends StatefulWidget {
  const SearchAppBarRefresh({Key key}) : super(key: key);

  @override
  _SearchAppBarRefreshState createState() => _SearchAppBarRefreshState();
}

class _SearchAppBarRefreshState extends State<SearchAppBarRefresh> {
  Dio _dio;

  @override
  void initState() {
    _dio = Dio(
        //BaseOptions(baseUrl: 'https://5f988a5242706e001695875d.mockapi.io'));
        BaseOptions(baseUrl: 'https://5f988a5242706e001695875d.mockapi.io'));

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      debugPrint(options.uri.toString());
      return options;
    }, onResponse: (response) async {
      // debugPrint(prettyJson(response.data, indent: 2));
      return response;
    }, onError: (DioError e) async {
      return e;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAppBarPageRefresh<Person>(
      //initialData: _initialData,x
      magnifyinGlassColor: Colors.white,
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'Search for a name',
      searchAppBartitle: Text(
        'Search Refresh Page',
        style: TextStyle(fontSize: 20),
      ),

      ///  Do not insert parentheses here.
      functionRefresh: _futureList,
      stringFilter: (Person person) => person.name,
      //stringFilter: (Person person) => person.age.toString(),
      //sortCompare: false,
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive verables into it.
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

  Future<List<Person>> _futureList() async {
    final response = await _dio.get('/users');

    return (response.data as List)
        .map((element) => Person.fromMap(element))
        .toList();
  }
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
  Dio _dio;

  Future<List<Person>> _futureList(int page, String query) async {
    final response = await _dio.get('/users', queryParameters: {
      /// It is necessary to insert sortBy to not bring names
      /// in wrong API orders.
      'sortBy': 'name',
      'name': query,
      'page': page,
      'limit': 15
    });

    return (response.data as List)
        .map((element) => Person.fromMap(element))
        .toList();
  }

  @override
  void initState() {
    _dio = Dio(
        BaseOptions(baseUrl: 'https://5f988a5242706e001695875d.mockapi.io'));

    /*_dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      debugPrint(options.uri.toString());
      return options;
    }, onResponse: (Response response) async {
      // debugPrint(prettyJson(response.data, indent: 2));
      return response;
    }, onError: (DioError e) async {
      return e;
    }));*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAppBarPagination<Person>(
        //initialData: _listPerson,
        //numItemsPage: _numItemsPage,
        magnifyinGlassColor: Colors.white,
        searchAppBarcenterTitle: true,
        searchAppBarhintText: 'Pesquise um Nome',
        searchAppBartitle: Text(
          'Search Pagination',
          style: TextStyle(fontSize: 20),
        ),
        //futureFetchPageItems: _futureListPerson,
        futureFetchPageItems: _futureList,
        stringFilter: (Person person) => person.name,
        //sortCompare: false,
        filtersType: FiltersTypes.contains,
        paginationItemBuilder:
            (BuildContext context, int index, Person objectIndex) {
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  title: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(50),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                          '${objectIndex.avatar}',
                        ),
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${objectIndex.name}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        });
  }

  /// How to configure the server side.
/*

  Future<List<Person>> _futureListPerson(int page, String query) async {
    final size = 15;
    List<Person> list = [];

    final fistElement = (page - 1) * size;
    final lastElement = page * size;

    */ /*print('fistElement = ' + fistElement.toString());
    print('lastElement = ' + lastElement.toString());
    print('--------');
    print('page pedida = ' + page.toString());
    print('--------');*/ /*

    dataListPerson3.sort((a, b) => a.name.compareTo(b.name));

    await Future<void>.delayed(Duration(seconds: 3));

    //return null;

    if (query.isEmpty) {
      int totalPages = (dataListPerson3.length / size).ceil();
      totalPages = totalPages == 0 ? 1 : totalPages;

      if (page > totalPages) {
        return list;
      }

      list = dataListPerson3.sublist(
          fistElement,
          lastElement > dataListPerson3.length
              ? dataListPerson3.length
              : lastElement);
    } else {
      final listQuery =
          dataListPerson3.where((element) => contains(element, query)).toList();

      int totalQueryPages = (listQuery.length / size).ceil();
      totalQueryPages = totalQueryPages == 0 ? 1 : totalQueryPages;

      if (page > totalQueryPages) {
        return list;
      }

      list = listQuery.sublist(fistElement,
          lastElement > listQuery.length ? listQuery.length : lastElement);
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

*/
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

class SimpleAppBarPage extends StatefulWidget {
  final StringFilter<Person> stringFilter;
  final FiltersTypes filtersType;
  final List<Person> listFull;
  final bool compare;

  const SimpleAppBarPage(
      {Key key,
      @required this.stringFilter,
      @required this.listFull,
      this.filtersType,
      this.compare})
      : super(key: key);

  @override
  _SimpleAppPageState createState() => _SimpleAppPageState();
}

class _SimpleAppPageState extends State<SimpleAppBarPage> {
  SimpleAppBarController<Person> _controller;

  @override
  void initState() {
    /// -------------------------------------------
    /// It is necessary to initialize the controller.
    /// -------------------------------------------
    _controller = SimpleAppBarController<Person>(
      listFull: widget.listFull,
      stringFilter: widget.stringFilter,
      sortCompare: widget.compare ?? true,
      filtersType: widget.filtersType,
    );

    _controller.bancoInitValue = true;
    super.initState();
  }

  /// -------------------------------------------------------------------------
  /// It was necessary to implement didUpdateWidget for setState and hot reload.
  /// -------------------------------------------------------------------------
  @override
  void didUpdateWidget(covariant SimpleAppBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.stringFilter = widget.stringFilter;
    //_controller.compareSort = widget.compareSort;
    _controller.sortCompare = widget.compare;
    _controller.filtersType = widget.filtersType;
    _controller.filter = widget.filtersType;

    if (oldWidget.listFull != widget.listFull) {
      _controller.listFull.clear();
      _controller.listFull.addAll(widget.listFull);
      _controller.sortCompareList(widget.listFull);

      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.refreshSeachList(_controller.rxSearch.value);
      } else {
        _controller.onSearchList(widget.listFull);
      }
    }
  }

  /// ----------------------------
  /// Controller close-up required.
  /// ----------------------------
  @override
  void dispose() {
    _controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
          controller: _controller,
          title: Text(
            'Search Page',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          hintText: 'Search for a name',
          magnifyinGlassColor: Colors.white),

      /// -------------------------------------
      /// Reactive widget for the filtered list.
      /// -------------------------------------
      body: RxListWidget<Person>(
        controller: _controller,
        obxListBuilder: (context, list, isModSearch) {
          // ☑️ This function is inside an Obx.
          // Place other reactive verables into it.

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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      ),
    );
  }
}

//class Person extends CacheJson {
class Person {
  final String name;

  final int age;
  final String id;
  final String avatar;
  final String username;
  final String image;

  Person({
    this.name,
    this.age,
    this.id,
    this.avatar,
    this.username,
    this.image,
  });

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return new Person(
      name: map['name'] as String,
      age: map['age'] as int ?? 0,
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      username: map['username'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
      'id': this.id,
      'avatar': this.avatar,
      'username': this.username,
      'image': this.image,
    };
  }
}

void changeAuth() {
  Future.delayed(const Duration(seconds: 5), () {
    ///------------------------------------------
    /// Test to check the reactivity of the screen.
    ///------------------------------------------
    /// 1) 👇🏼
    Get.find<Test2Controller>().rxList.addAll(dataListPerson);
    if (!Get.find<Test2Controller>().isAuth) {
      Get.find<Test2Controller>().changeAuth = true;
    }
  });
}

// ignore: must_be_immutable
class TestGetStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.find<Test2Controller>().changeAuth = false;
        Get.find<Test2Controller>().rxList.clear();
        return Future.value(true);
      },
      child: GetStreamPage<List<Person>>(
        title: Text(
          'Stream Page',
          style: TextStyle(fontSize: 18),
        ),
        stream: streamListPerson,

        ///--------------------------------------------
        /// ✅ Add RxBool auth and build the widget if it is false.
        ///---------------------------------------------
        rxBoolAuth: RxBoolAuth.input(
            rxBoolAuthm: Get.find<Test2Controller>().rxAuth,
            authFalseWidget: () => Center(
                  child: Text(
                    'Please login.',
                    style: TextStyle(fontSize: 22),
                  ),
                )),
        obxWidgetBuilder: (context, objesctStream) {
          ///------------------------------------------
          /// Build your body from the stream data.
          ///------------------------------------------
          final list = objesctStream;
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
            ],
          );
        },
      ),
    );
  }

  Stream<List<Person>> streamListPerson = (() async* {
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

// ignore: must_be_immutable
class TestStreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetStreamWidget'),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          Get.find<Test2Controller>().changeAuth = false;
          Get.find<Test2Controller>().rxList.clear();
          return Future.value(true);
        },
        child: GetStreamWidget<List<Person>>(
          stream: streamListPerson,
          obxWidgetBuilder: (context, objesctStream) {
            ///------------------------------------------
            /// Build your body from the stream data.
            ///------------------------------------------
            final list = objesctStream;
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
                                    'Age: '
                                    '${list[index].age.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Stream<List<Person>> streamListPerson = (() async* {
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

class Test2Controller extends GetxController {
  final rxAuth = false.obs;

  set changeAuth(bool value) => rxAuth.value = value;

  get isAuth => rxAuth.value;

  final rxList = <Person>[].obs;
}
