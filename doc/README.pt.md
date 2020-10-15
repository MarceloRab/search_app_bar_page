
# search_app_bar_page 

Um pacote Flutter para fornecer a você uma página de pesquisa simples.

## Introdução

Este pacote foi construído para gerar uma tela de busca completa e reativa com a melhor facilidade possível.
É baseado em outro pacote. Abra aqui => [search_app_bar] (https://pub.dev/packages/search_app_bar) (por - rodolfoggp@gmail.com). Lá você tem os detalhes das funções search_app_bar. Com as mudanças aqui,
você não precisa estender a classe do controlador, mas apenas passar a lista base a ser filtrada ou inserir
o fluxo que retorna sua lista para ser filtrada. Neste caso, já existe um StreamBuilder para fazer o
tratamento de fundo. Infelizmente, não consegui atualizar o pacote básico, pois Rodolfo não controlou o pacote
há mais de 01 ano e não respondeu ao meu pedido de alterações por e-mail.

![example_video](https://user-images.githubusercontent.com/41010018/94386509-426cb800-011e-11eb-975d-05bd57707b16.gif)

##### ✷ A página está dividida entre
- SEARCH_APP_BAR
- CONTROLADOR
- BODY de um Scaffold.

## Required parameters

Temos três páginas: <blockquote> SearchAppBarPage, SearchAppBarPageStream and  SearchAppBarPagination</blockquote>

🔎 <span> </span> ```SearchAppBarPage``` precisa de uma lista que é a lista completa a ser filtrada e uma função que é passada para construir
o widget dependendo da lista filtrada. Se você digitar a página, precisará de [stringFilter]. Esta é uma função que recebe
o parâmetro T (tipo de lista) e você o escolhe como a String de retorno do objeto. Como no exemplo abaixo. Foi digitado
como Person e retornou person.name. Isso será usado para filtrar pela consulta de pesquisa.

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

🔎 ```SearchAppBarPageStream``` precisa de um stream que já esteja trabalhado, ou seja, já existe um Widget por padrão
por erro e espera. Você pode modificá-los à vontade. Você também precisa de uma função que é passada para montar o widget
que será apresentado no Corpo, dependendo da lista filtrada. Isso é renovado pelo fluxo natural do stream
e também pela filtragem de pesquisa.

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


🔎 <span> </span> ```SearchAppBarPagination``` foi criado para solicitações fragmentadas de sua API. Se você tem centenas de dados e gostaria de enviá-los em partes, além de poder filtrá-los com eficiência, este Widget é o escolhido. Há um cache de solicitações para evitar (REST) ​​desnecessariamente. O cache é redefinido quando uma tela é descartada. O que difere do StreamPage é que uma função que encaminha a página e a consulta da string de pesquisa sempre será chamada quando necessário. Exemplo: atinge o final da página.
Lembrando que esta função deve retornar um Future (get para sua API). Você verá um exemplo com o lado do servidor abaixo [in Dart](https://github.com/MarceloRab/search_app_bar_page#example-of-server-side-function).


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

##### 😱 Você pode fazer um setState em sua página de stream e sua paginação ou um Rot Reload sem problemas. Mesmo mudando o valor de initialData.


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

### Exemplo de função do lado do servidor.

##### Atençao: O numero de itens por página deve ser mair que 14 ```(numItemsPage > 14)```.

Ex: Se numItemsPage = 20 (total de itens em uma página) e você envia uma lista com comprimento inferior a 20 ou envia uma lista vazia, = >>> significa que os dados acabaram. Se você enviar null: se ainda não houver dados, retorna uma Exceção; se um dado já existe, nada acontece.

#### Tipos de retorno para FetchPageItems futuros.

- Lista igual a numItemsPage ```(list.length == numItemsPage)``` = continua a solicitar novas notícias.
- Lista vazia ou lista menor que numItemsPage ```(list.length <numItemsPage)``` = termina a solicitação de páginas. Seja uma lista completa, seja a lista filtrada pela pesquisa. A solicitação da API para uma lista filtrada pela pesquisa só é atendida se a lista completa não for finalizada ou a solicitação da lista filtrada pela pesquisa não tiver sido finalizada pelos mesmos princípios acima.
- Retorno nulo. Se você enviar null: se ainda não houver dados, retorne uma Exceção; se um dado já existe, ele retorna os mesmos dados no cache. Por enquanto o cahe é reiniciado quando a tela recebe dispose;

##### Tive que passar algumas horas testando-o para que não houvesse erros. Faça testes e se encontrar algum erro, ficarei feliz em resolvê-los o mais rápido possível.

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

Estes são os filtros que o controlador usa para filtrar
 a lista. Divida os filtros em três tipos: 

```enum FiltersTypes { startsWith, equals, contains }```

Default = FiltersTypes.contains;

## Search_app_bar parameters

Aqui [parâmetros search_app_bar] (https://pub.dev/packages/search_app_bar#parameters),
no pacote básico, você pode entender cada componente.

<blockquote> NOVOS Componentes </blockquote>

## Reatividade à conexão.

`[iconConnectyOffAppBar]` Aparece quando o status da conexão está desligado. Já existe um ícone padrão.
Se você não quiser apresentar uma escolha `[hideDefaultConnectyIconOffAppBar]` = true; Se você quiser ter um ícone personalizado,
faça `[hideDefaultConnectyIconOffAppBar]` = true; e defina o `[iconConnectyOffAppBar]`.

`[widgetOffConnectyWaiting]` Mostra algo apenas quando está desconectado e ainda não tem o
primeiro valor do fluxo. Se a conexão voltar a mostrar o `[widgetWaiting]` até você
receber os primeiros dados. Todos já vêm com Todos vêm com widgets padrão.

![20201007-203744-360x780](https://user-images.githubusercontent.com/41010018/95398660-c708c480-08dc-11eb-8b07-e0ffa816cbbc.gif)

## Disclaimer

O design inicial deste pacote tem uma animação fornecida em um tutorial por Nishant Desai
em: https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

Todos os méritos para Rodolfo (rodolfoggp@gmail.com) e Nishant Desai.
