import 'package:diacritic/diacritic.dart';

import '../data_fake_api/list_person.dart';

Future<List<Person>> futureListPerson(int page, String query, int size) async {
  //const size = 8;
  List<Person> list = [];

  final fistElement = (page - 1) * size;
  final lastElement = page * size;

  /*print('fistElement = ' + fistElement.toString());
    print('lastElement = ' + lastElement.toString());
    print('--------');
    print('page pedida = ' + page.toString());
    print('--------');*/

  dataListPerson3.sort((a, b) => a.name!.compareTo(b.name!));

  await Future<void>.delayed(const Duration(seconds: 3));

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

  //throw Exception('Erro Voluntario');

  return list;
}

bool Function(Person person, String query) contains = (Person test, query) {
  final realTest = _prepareString(test.name!);
  final realQuery = _prepareString(query);
  return realTest.contains(realQuery);
};

String _prepareString(String string) => removeDiacritics(string).toLowerCase();
