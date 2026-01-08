# search_app_bar_page

A Flutter package to give you a simple search page.

## 🤖 AI / LLM Usage Instructions

**For AI Agents & Copilots:**

- **Standard List**: Use `SearchAppBarPage` (Memory list, no GetX).
- **GetX Reactive**: Use `SearchAppBarPageObx` (Memory list, GetX reactivity).
- **API/Async**: Use `SearchAppBarPageVariableList` (Async API calls via `onSearchList`).
- **Filtering**: Always use `whereFilter` parameter for local lists.
- **Config**: Map `title` to `searchAppBarTitle` and `actions` to `searchAppBarActions`.

Full decision tree and code snippets are available in the public library documentation (`///` comments) of `lib/search_app_bar_page.dart`.

## Introduction

This package was built to generate a complete and reactive search screen with the best possible
facility. It is based on another package. Open here
= > [search_app_bar](https://pub.dev/packages/search_app_bar) (by - rodolfoggp@gmail.com). There you
have the details of the search_app_bar functions. With the changes here, you do not need to extend
the controller class, but just pass the base list to be filtered or insert the stream that returns
your list to be filtered. In this case, there is already a StreamBuilder to do the background
treatment. Unfortunately, I was unable to update the basic package, as Rodolfo has not handled the
package for more than 01 year and has not responded to my request for changes by email.

![example_video](https://user-images.githubusercontent.com/41010018/94386509-426cb800-011e-11eb-975d-05bd57707b16.gif)

##### ✷ The page is divided between

- SEARCH_APP_BAR
- CONTROLLER
- BODY de um Scaffold.

## Required parameters

We have four pages: <blockquote> SearchAppBarPageVariableList, SearchAppBarPageObx, SearchAppBarPage, SearchAppBarPageStream, SearchAppBarPagination
and SimpleAppBarPage</blockquote>

🔎 `SearchAppBarPage`, `SearchAppBarPageObx` and `SearchAppBarPageVariableList` work similarly regarding filtering parameters. They need a function to build the Widget (`obxListBuilder`) depending on the filtered list.
If you use typed objects (Generic `<T>`), you need `[stringFilter]`. This is a function that receives the parameter T and returns the String to filter by.
Example: For a `Person` object, return `person.name`. This will be used to filter by the search query.

## Tips

The function `[obxListBuilder]` is inside an Obx. Place reactive verables into it.

##### ✳️ There are two ways to add reactive variables.

- Boot your controller into a StatefulWidget. <p>

* Pass the reactive variable inside this function `[obxListBuilder]` in SearchAppBarPage and
  SearchAppBarPageStream.

---

- Add reactive authentication parameters. Insert your RxBool that changes with the authentication
  status to reactivity. The body will be rebuilt when authentication is false.
  Set `[rxBoolAuth]` to SearchAppBarPage, SearchAppBarPageStream and SearchAppBarPagination.

[Example full](https://pub.dev/packages/search_app_bar_page/example) for more details. Both examples
in SearchAppBarPage.

---

- We just added `SearchAppBarPageObx`. If you have an `RxBool isLoading`, you can pass it inside the `obxListBuilder` function and it will control the loading while the list is being loaded. Unlike SearchAppBarPage where it was necessary to insert an Obx previously because the complete list is static.
- Use now `SearchAppBarPageObx`!

---

```dart
class SearchAppBarPageObx<T> extends StatefulWidget {
  //...

  SearchAppBarPageObx( //...
      /// Parameters for the SearcherGetController
      /// final RxList<T> listRx;
      @required this.listRx,

      /// [obxListBuilder] Function applied when it is filtering in search.
      @required this.obxListBuilder,

      /// [stringFilter] Required if you type.'
      ///You should at least type with String.
      this.stringFilter
      // or → (not both together)
      /// [whereFilter] Required if you type.
      /// Create your own function that returns a bool.
      this.whereFilter,
      //...
      )

///...
// Example:

        obxListBuilder:
          (
            BuildContext context,
            List<Model> list,
            bool isModSearch,
            int highLightIndex,
            /// Use highLightIndex to manipulate from the keyboard and select the item using [onEnter] or [onSubmit].
            /// There is a need to modify the list widget to move the scroll to the selected item, changing the background of the selected item.
            ///👉 highLightIndex goes from item 0 to item list.length - 1.
          ) {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (list.isEmpty) {
              return const Center(child: Text('Nothing was found'));
            }

            //...;

///...

}
```

- We added `SearchAppBarPageVariableList`. Use it when you need to search for a value in a list that is not static. It receives a `listVariableFunction` function that returns a `FutureOr<List<T>>`. This function is called every time the search query changes. It is useful for searching in an API or a database. Return a list of items from a query. Filter however you want.

```dart
class SearchAppBarPageVariableList <T> extends StatefulWidget {
  //...

  SearchAppBarPageVariableList ( //...
      /// Parameters para o SearcherGetController
      /// final ListVariableFunction<T>? listVariableFunction;

      /// [listVariableFunction] Function to fetch list items asynchronously or no.
      @required this.listVariableFunction,

      /// [obxListBuilder] Function applied when it is filtering in search.
      @required this.obxListBuilder,

      )
}
```

- We added `SearchAppBarPage`. Use it when you need to search for a value in a list that is static. It receives a `listFull` function that returns a `List<T>`. This function is called every time the search query changes. It is useful for searching in an API or a database. Return a list of items from a query. Filter however you want.

```dart
class SearchAppBarPage<T> extends StatefulWidget {
  //...

  SearchAppBarPage( //...
      /// Parameters para o SearcherGetController
      /// final List<T> listFull;
      @required this.listFull,

      /// [obxListBuilder] Function applied when it is filtering in search.
      @required this.obxListBuilder,

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
      controll_1.rxList.update((value) {});
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
    return realTestName.startsWith(realQuery) || realTestAge.startsWith(realQuery);
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
      //compare: false,
      ///--------------------------------------------
      /// ✅ Add the auth reactive parameters.
      ///  The body will be rebuilt when the auth is false.
      ///---------------------------------------------
      /// Do your own research manually.

      //whereFilter: startsWithListCalendar,

      onSubmit: (query, listFiltered) {
        debugPrint('🚀 main.dart - query - $query');
        debugPrint('🚀 main.dart - listFiltered - ${listFiltered.toString()}');
      },
      rxBoolAuth: RxBoolAuth.input(
          rxBoolAuthm: Get
              .find<TestController>()
              .rxAuth,
          authFalseWidget: () =>
              Center(
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

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}

```

🔎 `SearchAppBarPageStream` needs a stream that is already worked on, that is, there is already
a Widget by default for error and waiting. You can modify them at will. You also need a function
that is passed on to assemble the Widget that will be presented on the Body, depending on the
filtered list. This is renewed by the natural flow of the stream and also by the search filtering.

```dart
class SearchAppBarPageStream<T> extends StatefulWidget {
  //...

  SearchAppBarPageStream( //...
      /// final Stream<List<T>> listStream;
      @required this.listStream,

      ///final FunctionList<T> obxListBuilder;
      /// Function applied when receiving data through Stream or filtering in search.
      @required this.obxListBuilder,

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
      //compare: false,
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

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}

```

🔎 `SearchAppBarPageRefresh` need a Future that will be remade the Refresh. It is important not
to put parentheses in the parameter. See below.

```dart
class SearchAppBarPageRefresh<T> extends StatefulWidget {
  //...

  SearchAppBarPageRefresh( //...
      /// final FuncionRefresh<T> functionRefresh
      required this.functionRefresh,

      ///final FunctionList<T> obxListBuilder;
      /// Function applied when receiving data through Stream or filtering in search.
      @required this.obxListBuilder,

      /// [stringFilter] Required if you type.
      ///You should at least type with String.
      this.stringFilter
      // ...
      )
//...
}
```

#### 🔎 SearchAppBarRefresh

```dart

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
```

🔎 <span> </span> `SearchAppBarPagination` is built for fragmented requests for your API. If you
have hundreds of data and would like to send them in parts, in addition to being able to filter them
efficiently, this Widget is the chosen one. There is a cache of requests to avoid getting (REST)
unnecessarily. The cache reset when a screen is disposed. What differs from StreamPage is that a
function that forwards the page and the search string query will always be called when necessary.
Example: reaches the bottom of the page. Remembering that this function must return a Future (get
for your API). You will see an example with the server side
below [in Dart](https://github.com/MarceloRab/search_app_bar_page#example-of-server-side-function).

```dart
class SearchAppBarPagination<T> extends StatefulWidget {
  //...

  SearchAppBarPagination( //...
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
      @required this.futureFetchPageItems,

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
// ignore: must_be_immutable
class SearchAppBarPaginationTest extends StatefulWidget {
  const SearchAppBarPaginationTest({Key key}) : super(key: key);

  @override
  _SearchAppBarPaginationTestState createState() =>
      _SearchAppBarPaginationTestState();
}

class _SearchAppBarPaginationTestState extends State<SearchAppBarPaginationTest> {
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
        //compare: false,
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
}

class Person {
  final String name;

  final int age;

  Person({this.name, this.age});

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}
```

![WhatsApp-Video-2020-10-05-at-23 33](https://user-images.githubusercontent.com/41010018/95152485-8cc7e780-0763-11eb-9c77-55b3fe84fd61.gif)

### Example of server side function.

##### Attencion: The number of elements must be more than 14 `(numItemsPage > 14)`.

Ex: If numItemsPage = 20 (total items on a page) and you send a list with a length less than 20 or
send an empty list, = >>> means that the data is over. If you send null: if there is no data yet,
return an Exception; if a data already exists, nothing happens.

#### Return types for future FetchPageItems.

- List equal to numItemsPage `(list.length == numItemsPage)` = continues to request new pages.
- Empty list or list smaller than numItemsPage `(list.length < numItemsPage)` = ends the request
  for pages. Be it a complete list, be it the list filtered by the search. The API request for a
  list filtered by the search is only fulfilled if the complete list is not finalized or the list
  request filtered by the search has not been finalized by the same principles above.
- List longer than numItemsPage `(list.length> numItemsPage)` = return an Exception. The current
  page is calculated depending on the numItemsPage being constant.
- Null return. If you send null: if there is still no data, return an Exception; if a data already
  exists, it returns the same data in the cache. For now the cahe is restarted when the screen
  receives dispose.

##### ❕Tip: Build a cache of your requests for the API and setState your page without problems.

###### I had to spend a few hours testing it so there were no mistakes. Do tests and if you find an error, I would be happy to resolve them as soon as possible.

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

🔎 <span> </span> `SimpleAppBarPage` you need to do the work of assembling your page manually.
Start your controller, close it and implement the didUpdateWidget method for setState or Hot Reload
on your page. There is already a widget to fit the body of your page => [RxListWidget].

```dart
class SimpleAppBarPage extends StatefulWidget {
  final StringFilter<Person> stringFilter;
  final FiltersTypes filtersType;
  final List<Person> listFull;
  final bool compare;

  const SimpleAppBarPage({Key key,
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
```

#### Vide [Example full](https://pub.dev/packages/search_app_bar_page/example) for more details.

## Filters

These are the filters that the Controller uses to filter the list. Divide the filters into three
types:

`enum FiltersTypes { startsWith, equals, contains }`

Default = FiltersTypes.contains;

## Search_app_bar parameters

Here [search_app_bar parameters] (https://pub.dev/packages/search_app_bar#parameters), in the base
package, you can understand each component.

<blockquote> NEW Components </blockquote>

## Reactivity to the connection.

`[iconConnectyOffAppBar]` Appears when the connection status is off. There is already a default
icon. If you don't want to present a choice `[hideDefaultConnectyIconOffAppBar]` = true; If you want
to have a custom icon, do `[hideDefaultConnectyIconOffAppBar]` = true; and set
the `[iconConnectyOffAppBar]`.

`[widgetOffConnectyWaiting]` Only shows something when it is disconnected and does not yet have the
first value of the stream. If the connection goes back to show the `[widgetWaiting]` until you
receive the first data. Everyone already comes with They all come with default widgets.

![20201007-203744-360x780](https://user-images.githubusercontent.com/41010018/95398660-c708c480-08dc-11eb-8b07-e0ffa816cbbc.gif)

## Disclaimer

The initial design of this package has an animation provided in a tutorial by Nishant Desai
at: https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

All merits for Rodolfo (rodolfoggp@gmail.com) and Nishant Desai.

---

## New Components

#### ✷ GetStreamPage

A reactive page on GetX in a super simple way from your stream without a search.

There is already a Scaffold waiting for the parameters.

```dart
class TestGetStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get
            .find<Test2Controller>()
            .changeAuth = false;
        Get
            .find<Test2Controller>()
            .rxList
            .clear();
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
            rxBoolAuthm: Get
                .find<Test2Controller>()
                .rxAuth,
            authFalseWidget: () =>
                Center(
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

class Test2Controller extends GetxController {
  final rxAuth = false.obs;

  set changeAuth(bool value) => rxAuth.value = value;

  get isAuth => rxAuth.value;

  final rxList = <Person>[].obs;
}

class Test3Controller extends GetxController {
  final rx_2 = ''.obs;

  set rx_2(value) => rx_2.value = value;
}

class Person {
  final String name;

  final int age;

  Person({this.name, this.age});

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}
```

#### ✷ GetStreamWidget without Scaffold parameters.

#### ✷ Rx extension in reactive Widgets

Now you can assemble a Widget from RxString, RxInt, RxDouble, RxNumber and RxList. With the
`[getStreamWidget]` extension. It turns your Rx variable into a `[GetStreamWidget]`. If
there is nothing in the stream, it starts the wait. When you add something, it launches
obxBuilder. If there is an error, it starts the ErrorWidget. Ready to use.

```dart
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
              Get
                  .find<Test2Controller>()
                  .changeAuth = false;
              Get
                  .find<Test2Controller>()
                  .rxList
                  .clear();
              return Future.value(true);
            }),

        /// Transform Rx in Widget with extensions
        child: Get
            .find<Test2Controller>()
            .rxList
            .getStreamWidget(
          obxWidgetBuilder: (context, objesctStream) {
            final list = objesctStream;
            if (list == null || list.isEmpty) {
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
                            child: Text(
                              'Name: ${list[index].name}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}

```

#### Vide [Example full](https://pub.dev/packages/search_app_bar_page/example) for more details.
