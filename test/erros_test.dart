import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_pagination_future_controller.dart';

import 'data_fake_api/list_person.dart';
import 'infra_fakes_data/fake_get_api_function.dart';

final controllerPagination = SearcherPagePaginationFutureController<Person>(
  //listStream: widget._stream,
  stringFilter: (Person person) => person.name,
  //compareSort: (Person a, Person b) => a.name.compareTo(b.name),
  //filtersType: FiltersTypes.contains
);

void main() {
  test('Deve lancar uma Exception', () {
    final Completer completer = Completer();

    const size = 10;
    const page = 1;
    const fistElement = (page - 1) * size;
    const lastElement = page * size;
    futureListPerson(page, '', size).then<void>((List<Person> data) {
      if (data.isEmpty) {
        completer.complete(<Person>[]);
        return;
      }

      if (data.length - size < 0) {
        completer.complete(data);
        return;
      }
      completer.complete(data);
    }, onError: (Object error) {
      //final tipo = error as Exception;

      //print(' TEST Exception --  ${tipo.toString()}');
      //print(' TEST Exception --  ${(error is Exception).toString()}');

      completer.complete(error);
    });

    completer.future.then((value) {
      expect(
          completer,
          dataListPerson3.sublist(
              fistElement,
              lastElement > dataListPerson3.length
                  ? dataListPerson3.length
                  : lastElement));
    }, onError: (Object error) {
      expect(error, isA<Exception>());
    });
    //expect(completer, isA<Exception>());
  });
}
