import 'package:flutter_test/flutter_test.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_pagination_future_controller.dart';

import 'data_fake_api/list_person.dart';
import 'infra_fakes_data/fake_get_api_function.dart';

final controllerPagination = SearcherPagePaginationFutureController<Person>(
  //listStream: widget._stream,
  stringFilter: (Person person) => person.name,
  //compareSort: (Person a, Person b) => a.name.compareTo(b.name),
  //filtersType: FiltersTypes.contains
)..onInitFilter();

void main() {
  const page = 2;
  test('Pragina ${page.toString()} com 10 elementos', () async {
    const size = 15;

    const fistElement = (page - 1) * size;
    const lastElement = page * size;
    final result = await futureListPerson(page, '', size);

    //expect(result, isA<List<ResultModel>>());
    expect(
        result,
        dataListPerson3.sublist(
            fistElement,
            lastElement > dataListPerson3.length
                ? dataListPerson3.length
                : lastElement));
  });
}
