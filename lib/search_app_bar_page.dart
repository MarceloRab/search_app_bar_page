/// Library: search_app_bar_page
///
/// # AI Implementation Guide
///
/// When asked to build a screen using this package, follow this decision tree:
///
/// ## 1. Decision Tree
///
/// *   **Scenario A: Asynchronous API/Database Filter**
///     *   Use `[SearchAppBarPageVariableList]`
///     *   **Must** implement `onSearchList` parameter.
///
/// *   **Scenario B: Full List in Memory + GetX**
///     *   Use `[SearchAppBarPageObx]`
///     *   Pass your `RxList` to the `list` parameter.
///
/// *   **Scenario C: Full List in Memory + Standard State**
///     *   Use `[SearchAppBarPage]`
///     *   Pass your `List` to the `listFull` parameter.
///     *   **Must** implement `whereFilter` (avoid `stringFilter`).
///
/// ## 2. Core Implementation Patterns
///
/// ### API Search (Variable List)
/// ```dart
/// SearchAppBarPageVariableList<Person>(
///   onSearchList: (query) => api.searchPersons(query),
///   searchAppBarTitle: Text("API Search"),
///   body: (context, foundList, index) => ListTile(title: Text(foundList[index].name)),
/// )
/// ```
///
/// ### GetX Reactive (Obx)
/// ```dart
/// SearchAppBarPageObx<Person>(
///   list: controller.rxList,
///   whereFilter: (p, query) => p.name.contains(query),
///   searchAppBarTitle: Text("GetX Search"),
///   itemBuilder: (context, index, person) => ListTile(title: Text(person.name)),
/// )
/// ```
///
/// ### Standard Full List
/// ```dart
/// SearchAppBarPage<Person>(
///   listFull: persons,
///   whereFilter: (p, query) => p.name.contains(query),
///   searchAppBarTitle: Text("Local Search"),
///   body: (context, list, index) => ListTile(title: Text(list[index].name)),
/// )
/// ```
library search_app_bar_page;

export 'src/search_app_bar_page/controller/simple_app_bar_controller.dart';
export 'src/search_app_bar_page/controller/utils/filters/filters_type.dart';
export 'src/search_app_bar_page/extensions/rx_widgets_extensions.dart';
export 'src/search_app_bar_page/ui/core/search_app_bar/search_app_bar.dart';
export 'src/search_app_bar_page/ui/get_stream_page.dart';
export 'src/search_app_bar_page/ui/get_stream_widget.dart';
export 'src/search_app_bar_page/ui/infra/rx_get_type.dart';
export 'src/search_app_bar_page/ui/search_app_bar_page.dart';
export 'src/search_app_bar_page/ui/search_app_bar_page_obx.dart';
export 'src/search_app_bar_page/ui/search_app_bar_page_refresh.dart';
export 'src/search_app_bar_page/ui/search_app_bar_page_stream.dart';
export 'src/search_app_bar_page/ui/search_app_bar_page_variable_list.dart';
export 'src/search_app_bar_page/ui/search_app_bar_pagination.dart';
export 'src/search_app_bar_page/ui/widgets/rx_list_builder.dart';
