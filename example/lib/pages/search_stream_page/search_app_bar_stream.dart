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
