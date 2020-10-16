import 'package:flutter_test/flutter_test.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_pagination_future_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

import 'data_fake_api/list_person.dart';

final controllerPagination = SearcherPagePaginationFutureController<Person>(
  //listStream: widget._stream,
  stringFilter: (Person person) => person.name,
  compareSort: (Person a, Person b) => a.name.compareTo(b.name),
  //filtersType: FiltersTypes.contains
)..onInitFilter();

void main() {
  /*
  const page = 2;
  const size = 10;
  const fistElement = (page - 1) * size;
  const lastElement = page * size;
  final downlodListFull =
      ListSearchBuild(listSearch: dataListPerson3, isListSearchFull: true);

  final downlodListFullTwoPages = ListSearchBuild(
      listSearch: dataListPerson3.sublist(
          fistElement,
          lastElement > dataListPerson3.length
              ? dataListPerson3.length
              : lastElement),
      isListSearchFull: true);
  */

  controllerPagination.numItemsPage = 10;
  controllerPagination.listFull = dataListPerson3;

  test('Search Page com query empty. Deve retornar 20 elementos', () {
    final listBuilder = controllerPagination.haveSearchQueryPage('');

    expect(listBuilder.listSearch.length, 43);
    //expect(listBuilder.isListSearchFull, false);
  });

  test('Retornar lista filtrada por m', () {
    final listBuilder = controllerPagination.haveSearchQueryPage('m');

    expect(
        listBuilder.listSearch,
        controllerPagination.sortCompareListSearch(controllerPagination.listFull
            .where((element) => Filters.contains(
                controllerPagination.stringFilter(element), 'm'))
            .toList()));
    //expect(listBuilder.isListSearchFull, false);
  });

  test('Retornar lista filtrada por ma', () {
    final listBuilder = controllerPagination.haveSearchQueryPage('ma');

    expect(
        listBuilder.listSearch,
        controllerPagination.sortCompareListSearch(controllerPagination.listFull
            .where((element) => Filters.contains(
                controllerPagination.stringFilter(element), 'ma'))
            .toList()));
    //expect(listBuilder.isListSearchFull, false);
  });

  test('Retornar lista filtrada por marcelo, retirada da filtrada por ma', () {
    //final listBuilder = controllerPagination.buildPreviousList('marcelo');

    /*expect(
        listBuilder.listSearch,
        controllerPagination.sortCompareListSearch(controllerPagination.listFull
            .where((element) => Filters.contains(
            controllerPagination.stringFilter(element), 'ma'))
            .toList()));
            */
    final listBuilder = controllerPagination.haveSearchQueryPage('marcelo');
    //print('${listBuilder.listSearch.length.toString()}');

    expect(
        listBuilder.listSearch,
        controllerPagination.sortCompareListSearch(controllerPagination.listFull
            .where((element) => Filters.contains(
                controllerPagination.stringFilter(element), 'ma'))
            .toList()
            .where((element) => Filters.contains(
                controllerPagination.stringFilter(element), 'marcelo'))
            .toList()));
    //expect(listBuilder.isListSearchFull, false);
  });
}
