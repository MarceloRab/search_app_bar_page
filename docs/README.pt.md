# search_app_bar_page 

Um pacote em Flutter para lhe dar uma search page.

## Introduction

Este pacote foi construido para gerar uma tela de search completa e reativa com a melhor facilidade possível. 
Ele tem como base outro pacote. Gostaria de 👀 como fica a animação? Abra aqui [search_app_bar](https://pub.dev/packages/search_app_bar) 
(by - rodolfoggp@gmail.com). Lá você tem os pormenores das funções do search_app_bar. Com as mudanças aqui, 
voce não vai precisar extender a classe controller mas apenas passar a lista base para ser filtrada ou insira 
a stream que devolve a sua lista para ser filtrada. Nesta caso, já existe um StreamBuilder para fazer o 
tratamento em pano de fundo. 

Obs.: Minha real intenção era atualizar o projeto do Rodolfo, mas já mandei algumas mensagens, a primeira há 06 meses, e não obtenho resposta.
O projeto dele esta parado há mais de 01 ano.

##### As página se divide entre: 
-  SEARCH_APP_BAR 
-  CONTROLLER
- BODY de um Scaffold.

## Parâmetros necessários

![](lib/img/example_video.mp4)

Temos duas páginas: <blockquote> SearchAppBarPage e SearchAppBarPageStream.</blockquote>

🔎 <p> SearchAppBarPage precisa de uma lista que é a lista completa a ser filtrada e uma função que é repassada 
       para montar o Widget a depender da lista filtrada. Se você tipar a página, se faz necessário [stringFilter].
       Esta é uma função que recebe o parâmetro T (tipo da lista) e você escolhe como o String de retorno a partir 
       do objeto. Como no exemplo abaixo. Foi tipada como Person e retornou o person.name. Este será usado para filtrar pelo query do search.

```dart
SearchAppBarPage({ 
       Key key,
       /// Parametros para o SearcherGetController
       @required this.listFull, 
       @required this.listBuilder,
       this. StringFilter,    /// If not, it is understood that the type will be String. 
      /// Caso não tipe, subtendem-se String por padrão.
             ...
```

🔎 <p> SearchAppBarPageStream precisa de um stream que já é trabalhado, ou seja, já existe um Widget por 
       padrão de erro e espera. Você pode modificá-los a vontade Também precisa de uma função que é repassada 
       para montar o Widget que será apresentado no Body, a depender da lista filtrada. Esta é renovada pelo 
       fluxo natural do stream e também pelo filtragem do Search. 

```dart 
SearchAppBarPageStream({
    Key key,
    /// Parametros para o SearcherGetController
    @required this.listStream, /// final Stream<List<T>> listStream;
    @required this.listBuilder,
             ...
```

## Exemplo 
###### See [Example](https://pub.dev/packages/search_app_bar_page/example) para mais detalhes.
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



## Filtros

Divide os filtros em três tipos:

```enum FiltersTypes { startsWith, equals, contains }```

Default = FiltersTypes.contains;

## Parametros do search_app_bar

Aqui [search_app_bar paremetros](https://pub.dev/packages/search_app_bar#parameters), 
no pacote base, você pode entender cado compenente.
<blockquote> Componentes NOVOS </blockquote>

``` [iconConnectyOffAppBar]``` Aparece quando o status da conexao é off. Já existe um icone default. Caso nao queira apresentar escolha
``` [showIconConnectyOffAppBar]```  = false; default = true.

``` [widgetConnecty]``` Apenas mostra algo quando esta sem conexao e ainda nao tem o primeiro valor da stream. Se a conexao voltar passa a mostrar o 
``` [widgetWaiting]```  até apresentar o primeiro dado. Todos já vem com widgets default.

## Disclaimer

O projeto inicial deste pacote tem uma animação fornecida em um tutorial by Nishant Desai
at: https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

Todos os méritos para Rodolfo (rodolfoggp@gmail.com) e Nishant Desai.
