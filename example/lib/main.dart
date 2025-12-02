// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'package:diacritic/diacritic.dart';

import 'package:diacritic/diacritic.dart';
import 'package:example/page_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:search_app_bar_page/search_app_bar_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SearchAppBarPage',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      //initialBinding: MyBindings(),
    ),
  );
}

class MyBindings extends BindingsInterface {
  @override
  void dependencies() {
    Get.put(TestController());
  }
}

abstract class Routes {
  static const HOME = '/home';
  static const PAGE_1 = '/page-1';
  static const PAGE_2 = '/page-2';
  static const PAGE_5 = '/page-5';
  /* static const PAGE_3 = '/page-3';
  static const PAGE_4 = '/page-4';
  static const PAGE_5 = '/page-5';
  static const PAGE_6 = '/page-6';
  static const PAGE_7 = '/page-7'; */
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: MyBindings()),
    GetPage(name: Routes.PAGE_1, page: () => const SearchAppBarStream()),
    GetPage(name: Routes.PAGE_2, page: () => SearchPage()),
    GetPage(
      name: Routes.PAGE_5,
      // ignore: top_level_function_literal_block
      page: () {
        Get.put(Test2Controller());
        changeAuth();
        return TestGetStreamPage();
      },
    ),
  ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
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
                child: const Text(
                  'Go to the SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_1);
                },
                child: const Text(
                  'Go to the SearchStreamPage',
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

  //bool get isAuth => rxAuth.value;

  final rxList = <Person>[].obs;
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TestController controll_1 = Get.find<TestController>();

  /// ## ✳️ Learning both ways to add reactive variables.
  @override
  void initState() {
    ///-------------------------------------------------------------------
    ///  Add other reactive parameters inside the body.
    /// ✅  Boot your controller into a StatefulWidget.
    ///-------------------------------------------------------------------

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
      // ignore: invalid_use_of_protected_member
      controll_1.rxList.refresh();
    });
  }

  bool startsWithListCalendar(Person test, String? query) {
    if (query == null) {
      return false;
    }
    final realTestName = removeDiacritics(test.name).toLowerCase();
    final realTestAge = removeDiacritics(test.age.toString()).toLowerCase();

    final realQuery = removeDiacritics(query.toLowerCase());
    // return realTest.contains(realQuery);
    return realTestName.startsWith(realQuery) ||
        realTestAge.startsWith(realQuery);
  }

  final GlobalKey<SearchAppBarPageState<Person>> searchAppBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //return SearchAppBarPage<String>(
    return SearchAppBarPage<Person>(
      autoFocus: false,
      key: searchAppBarKey,
      magnifyGlassColor: Colors.black,
      searchAppBarCenterTitle: true,
      searchAppBarHintText: 'Search for a name',
      searchTextColor: Colors.red,
      searchAppBarActions: [
        IconButton(
          icon: const Icon(Icons.pageview),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Search Dialog'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 400,
                  child: SearchAppBarPage<Person>(
                    searchAppBarTitle: const Text('Search in Dialog'),
                    searchAppBarHintText: 'Search for a name',
                    listFull: dataListPerson2,
                    stringFilter: (Person person) => person.name,
                    filtersType: FiltersTypes.contains,
                    obxListBuilder: (context, list, isModSearch) {
                      if (list.isEmpty) {
                        return const Center(
                          child: Text('NOTHING FOUND'),
                        );
                      }
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(list[index].name),
                            subtitle: GestureDetector(
                                child: Text('Age: ${list[index].age}')),
                            onTap: () {
                              Navigator.of(context).pop(list[index]);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ],

      /// Do your own research manually.
      //whereFilter: startsWithListCalendar,
      searchAppBarTitle: const Text(
        'Search Page',
        style: TextStyle(fontSize: 20),
      ),

      ///
      onSubmit: (query, listFiltered) {
        debugPrint('🚀 main.dart - query - $query');
        debugPrint('🚀 main.dart - listFiltered - ${listFiltered.toString()}');
      },

      /// Add list. Use setState if your list changes.
      listFull: dataListPerson2,

      /// sort default compare by stringFilter return.

      //sortFunction: (Person a, Person b) => a.age.compareTo(b.age),

      //filtersType: FiltersTypes.equals,

      stringFilter: (Person person) => person.name,

      /// If you want to make your own filtering function.
      /// 👇🏼
      /*filter: (Person person, String query) {
        final intQuery = int.tryParse(query);
        if (intQuery != null) {
          return person.age.compareTo(intQuery) == 0;
        }
        /// show warning
        return true;
      },*/

      ///--------------------------------------------
      /// ✅ Add the auth reactive parameters.
      ///  The body will be rebuilt when the auth is false.
      ///---------------------------------------------
      rxBoolAuth: RxBoolAuth.input(
          rxBoolAuthm: Get.find<TestController>().rxAuth,
          authFalseWidget: () => const Center(
                child: Text(
                  'Please login.',
                  style: TextStyle(fontSize: 22),
                ),
              )),
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive variables into it.

        ///----------------------------------------------------
        /// Changes to the rxList will also rebuild the widget.
        ///----------------------------------------------------
        print(' TEST -- ${controll_1.rxList.length.toString()} ');

        ///-------------------------------------------------------------
        /// Changes to the filtered list will also reconstruct the body.
        ///-------------------------------------------------------------
        if (list.isEmpty) {
          return const Center(
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
                        child: TextButton(
                          onPressed: () {
                            searchAppBarKey.currentState?.clearSearch();
                            Get.to(() => const MyWidget());
                          },
                          child: Text(
                            'Name: ${list[index].name}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Age: ${list[index].age.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
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
  const SearchAppBarStream();

  @override
  _SearchAppBarStreamState createState() => _SearchAppBarStreamState();
}

class _SearchAppBarStreamState extends State<SearchAppBarStream> {
  String _prepareString(String string) =>
      removeDiacritics(string).toLowerCase();

  bool myWhereFunction(Person person, String? query) {
    if (query == null) {
      return false;
    }
    debugPrint('🚀 main.dart - person.name - ${person.name}');
    final realTest = _prepareString(person.name);
    final realQuery = _prepareString(query);
    final test = realTest.startsWith(realQuery);
    debugPrint('🚀 main.dart - test - $test');
    return test;
  }

  @override
  Widget build(BuildContext context) {
    return SearchAppBarPageStream<Person>(
      //initialData: _initialData,
      //magnifyinGlassColor: Colors.white,
      searchAppBarCenterTitle: true,
      searchAppBarHintText: 'Search for a name',
      searchAppBarTitle: const Text(
        'Search Stream Page',
        style: TextStyle(fontSize: 20),
      ),

      /// Add stream. Use setState if your stream change.
      listStream: _streamListPerson,
      //whereFilter: myWhereFunction,
      stringFilter: (Person person) => person.name,
      //stringFilter: (Person person) => person.age.toString(),
      /// sort default compare by stringFilter return.
      sortFunction: (Person a, Person b) => a.age.compareTo(b.age),
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive variables into it.
        if (list.isEmpty) {
          return const Center(
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
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Age: ${list[index].age.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
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
                child: const Text(
                  'Ir para SearchPage',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text(
                  'SetState',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        );
      },
    );
  }

  final Stream<List<Person>> _streamListPerson = (() async* {
    await Future<void>.delayed(const Duration(seconds: 3));
    //yield null;
    yield dataListPerson;
    await Future<void>.delayed(const Duration(seconds: 4));
    yield dataListPerson2;
    await Future<void>.delayed(const Duration(seconds: 5));
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
  Person(name: 'Rafael Pereira', age: 15),
  Person(name: 'Nome Comum', age: 33),
];

// ignore: must_be_immutable

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
  Person(name: 'Fábio Melo', age: 51),
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
  Person(name: 'William Carvalho', age: 47),
  Person(name: 'Elias Tato', age: 22),
  Person(name: 'Dada IstoMesmo', age: 44),
  Person(name: 'Nome Incomum', age: 52),
  Person(name: 'Qualquer Nome', age: 9),
  Person(name: 'First Last', age: 11),
  Person(name: 'Bom Dia', age: 23),
  Person(name: 'Bem Malaquias', age: 13),
  Person(name: 'Mal Miqueias', age: 71),
  Person(name: 'Quem Sabe', age: 35),
  Person(name: 'Miriam Leitão', age: 33),
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

// ignore: must_be_immutable
class SimpleAppBarPage extends StatefulWidget {
  final StringFilter<Person> stringFilter;
  final FiltersTypes filtersType;
  final List<Person> listFull;
  bool compare = false;

  SimpleAppBarPage(
      {super.key,
      required this.stringFilter,
      required this.filtersType,
      required this.listFull,
      required this.compare});

  @override
  _SimpleAppPageState createState() => _SimpleAppPageState();
}

class _SimpleAppPageState extends State<SimpleAppBarPage> {
  late final SimpleAppBarController<Person> _controller;

  @override
  void initState() {
    /// -------------------------------------------
    /// It is necessary to initialize the controller.
    /// -------------------------------------------
    _controller = SimpleAppBarController<Person>(
      listFull: widget.listFull,
      stringFilter: widget.stringFilter,
      sortCompare: widget.compare,
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
          title: const Text(
            'Search Page',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          hintText: 'Search for a name',
          magnifyGlassColor: Colors.white),

      /// -------------------------------------
      /// Reactive widget for the filtered list.
      /// -------------------------------------
      body: RxListWidget<Person>(
        controller: _controller,
        obxListBuilder: (context, list, isModSearch) {
          // ☑️ This function is inside an Obx.
          // Place other reactive verables into it.

          if (list.isEmpty) {
            return const Center(
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
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Age: ${list[index].age.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
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

  Person({
    required this.name,
    required this.age,
  });

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}

void changeAuth() {
  Future.delayed(const Duration(seconds: 5), () {
    ///------------------------------------------
    /// Test to check the reactivity of the screen.
    ///------------------------------------------
    /// 1) 👇🏼
    Get.find<Test2Controller>().rxList.addAll(dataListPerson2);

    Get.find<Test2Controller>().changeAuth = true;
    /* final controller = Get.find<Test2Controller>();
    final isAuth = controller.isAuth;
    if (isAuth) {
      Get.find<Test2Controller>().changeAuth = true;
    } */
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

      /// Have a Scaffold
      child: GetStreamPage<List<Person>>(
        title: const Text(
          'Stream Page',
          style: TextStyle(fontSize: 18),
        ),
        stream: streamListPerson,

        ///--------------------------------------------
        /// ✅ Add RxBool auth and build the widget if it is false.
        ///---------------------------------------------
        rxBoolAuth: RxBoolAuth.input(
            rxBoolAuthm: Get.find<Test2Controller>().rxAuth,
            authFalseWidget: () => const Center(
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
            return const Center(
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
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Age: ${list[index].age.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12),
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
    await Future<void>.delayed(const Duration(seconds: 3));
    //yield null;
    yield dataListPerson;
    await Future<void>.delayed(const Duration(seconds: 4));
    yield dataListPerson2;
    await Future<void>.delayed(const Duration(seconds: 5));
    //throw Exception('Erro voluntario');
    yield dataListPerson3;
  })();
}

// ignore: must_be_immutable

class Test2Controller extends GetxController {
  final rxAuth = false.obs;

  set changeAuth(bool value) => rxAuth.value = value;

  get isAuth => rxAuth.value;

  final rxList = <Person>[].obs;
}
