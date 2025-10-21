# AI coding agent guide for `search_app_bar_page`

This repo is a Flutter package that delivers complete, reactive search pages with an animated search AppBar. It’s built on GetX reactivity (v5 RC) and exposes three primary page types plus a simple AppBar.

## Big picture

- Core idea: give consumers a drop-in Search AppBar + page that filters lists (local, stream, or paginated) with minimal wiring.
- Main entrypoints (exported in `lib/search_app_bar_page.dart`):
  - `SearchAppBarPage<T>` – filter an in-memory list
  - `SearchAppBarPageStream<T>` – filter a list delivered by a `Stream<List<T>>`
  - `SearchAppBarPagination<T>` – incremental fetching with page/query, managed cache, and list scrolling
  - `SearchAppBar<T>` – the animated AppBar used internally (can be used standalone)
- Controllers encapsulate behavior and state (GetX `Rx`):
  - `SearcherPageController<T>`, `SearcherPageStreamController<T>`, `SearcherPagePaginationController<T>`
  - All implement or follow `SearcherBase<T>` (see `controller/searcher_base_control.dart`).
- Filtering primitives live in `controller/utils/filters/`:
  - `FiltersTypes` enum and `Filters.{startsWith|equals|contains}`; `StringFilter<T>`, `WhereFilter<T>`, `Filter<T>` typedefs.

## Key behaviors and why they’re structured this way

- AppBar UX: `ui/core/search_app_bar/search_app_bar.dart` uses a tap ripple (see `search_paint.dart`) to enter search mode and overlays `SearchWidget` with back/clear and a focused `TextField`. The ripple starts where the AppBar was tapped (`TapUpDetails.globalPosition`).
- Reactivity: `SearchWidget` updates `controller.rxSearch`; pages `debounce` and rebuild body in `Obx`. This isolates search/query state from view rendering.
- Filtering contract:
  - If `T == String`, you can omit `stringFilter`.
  - Otherwise provide exactly one of: `stringFilter` OR `whereFilter` OR `filter`.
  - `sortCompare` (default true) sorts by `stringFilter` result unless you pass a custom `sortFunction` (page + stream variants support it).
  - Strings are normalized with `diacritic.removeDiacritics` and lowercased before comparing.
- Auth gating: Optional `RxBoolAuth` lets you swap the page body when `auth == false` (see `ui/infra/rx_get_type.dart`).
- Stream variant: `SearchAppBarPageStream` subscribes to `Stream<List<T>>`, mirrors state to an `AsyncSnapshot<List<T>>`, and applies search filtering on top. Do not emit `null`; errors become UI via `widgetErrorBuilder`.
- Pagination variant: `SearcherPagePaginationController` caches per-query pages (`mapsSearch`) and manages two flows (full-list scroll and search-scroll) with flags to avoid duplicate fetches. First page must be well-formed (see pitfalls below).

## How to use (repo examples)

- See `README.md` and `example/` for full snippets. Typical in-memory usage:
  - `SearchAppBarPage<Person>(listFull: people, stringFilter: (p) => p.name, obxListBuilder: ...)`
- Stream usage:
  - `SearchAppBarPageStream<Person>(listStream: stream, stringFilter: (p) => p.name, obxListBuilder: ...)`
- Pagination usage:
  - `SearchAppBarPagination<Person>(futureFetchPageItems: (page, q) => api(page, q), numItemsPage: 15, stringFilter: (p) => p.name, paginationItemBuilder: ...)`

## Local conventions and gotchas

- Lint rules come from `package:lint` with overrides in `analysis_options.yaml` (e.g., prefer single quotes; long lines allowed). Match existing style when editing.
- `SearchWidget.onSubmitted` only triggers `onSubmit` for the in-memory page (`SearcherPageController`). Stream/pagination leave `onSubmit` commented out.
- `bancoInit` flags when initial data exists to show the magnifying glass; set by controllers when first lists arrive.
- Stream variant treats `null` lists as errors and shows a default error widget unless `widgetErrorBuilder` is provided.
- Pagination expectations:
  - If you pass `initialData`, you must also pass `numItemsPage`.
  - Minimum `numItemsPage` is 15; first server response should be ≥15 (or exactly `numItemsPage`) unless it’s the final page.
  - Returning more than `numItemsPage` items for a page is treated as an error.

## Build, test, and debug

- Package uses Flutter 3 (Dart >= 3.2.6). Dependencies: `get` (v5 RC), `diacritic`.
- Run tests (unit + pagination logic in `test/`):
  - PowerShell: `flutter test`
- Try the example app under `example/` to validate visually:
  - PowerShell: `flutter run` (from `example/`)

## Where to look when implementing changes

- AppBar and search UI: `ui/core/search_app_bar/`
- Page scaffolds: `ui/search_app_bar_page*.dart`
- Controllers and business logic: `controller/*.dart`
- Filters/types: `controller/utils/filters/`
- Tests and fake data: `test/`

If anything here feels off or you need additional org-specific workflows (CI, publishing steps, or custom scripts), tell me what’s missing and I’ll refine this guide.
