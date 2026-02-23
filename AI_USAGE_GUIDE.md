# AI Usage Guide for `search_app_bar_page`

This document provides instructions for AI agents on how to correctly implement the `search_app_bar_page` package. **When asked to "build a screen using search_app_bar", follow this decision tree and use the provided code patterns.**

## Decision Tree: Which Widget to Use?

1. **Are you filtering data from an API or Database asynchronously?**
   - **YES** -> Use `SearchAppBarPageVariableList`.
   - **NO** (You have the full list in memory) -> Go to step 2.

2. **Are you using GetX for State Management?**
   - **YES** -> Use `SearchAppBarPageObx`.
   - **NO** -> Use `SearchAppBarPage`.

---

## 1. Scenario: Full List + No GetX (Standard)

**Use Case:** You have a simple list (e.g., `List<String>` or `List<Person>`) and aren't using GetX.

```dart
SearchAppBarPage<Person>(
  // 1. Provide the full list
  listFull: personList,

  // 2. Define how to filter (CRITICAL: Use whereFilter, NOT stringFilter)
  whereFilter: (person, query) =>
      person.name.toLowerCase().contains(query.toLowerCase()),

  // 3. Configure the AppBar
  searchAppBarTitle: Text("Search People"),
  searchAppBarActions: [
    IconButton(icon: Icon(Icons.info), onPressed: () {}),
  ],

  // 4. Build your list item
  body: (context, filteredList, index) {
      final person = filteredList[index];
      return ListTile(title: Text(person.name));
  },
)
```

## 2. Scenario: Full List + GetX (Reactive)

**Use Case:** You have a `RxList` (e.g., `final list = <Person>[].obs`) and want automatic updates.

```dart
// Controller
final RxList<Person> personList = <Person>[].obs;
final RxString expandedTopicId = ''.obs;

// UI
SearchAppBarPageObx<Person>(
  // 1. Pass the RxList directly
  listRx: controller.personList,

  // 2. Filter logic
  whereFilter: (person, query) =>
      person.name.toLowerCase().contains(query.toLowerCase()),

  // 3. AppBar Config
  searchAppBarTitle: Text("Search w/ GetX"),

  // 4. Keyboard Navigation (Optional but recommended for Web/Desktop)
  onSubmit: (query, listFiltered, highLightIndex) {
    if (highLightIndex >= 0 && highLightIndex < listFiltered.length) {
      // Trigger action based on the highlighted item (e.g., expand it)
      controller.expandedTopicId.value = listFiltered[highLightIndex].id;
    }
  },
  onEnter: (listFull, highLightIndex) {
    if (highLightIndex >= 0 && highLightIndex < listFull.length) {
      controller.expandedTopicId.value = listFull[highLightIndex].id;
    }
  },

  // 5. Use obxListBuilder to access 'highlight' index for interactive list items
  obxListBuilder: (context, foundList, isModSearch, highlightIndex) {
    return ListView.builder(
      itemCount: foundList.length,
      itemBuilder: (context, index) {
        final person = foundList[index];
        final isHighlighted = index == highlightIndex;
        // Apply visual changes when 'isHighlighted' is true
        return ListTile(
            title: Text(person.name),
            tileColor: isHighlighted ? Colors.blue.withAlpha(20) : null,
        );
      },
    );
  },
)
```

_Note: The `highlightIndex` is particularly useful for Web and Desktop navigation where the user can use the Up/Down arrow keys. Combine it with `Scrollable.ensureVisible` inside your custom items for automatic scrolling._

## 3. Scenario: API / Async Filtering (Variable List)

**Use Case:** You don't have the full list. You send a query to an API and get a list back.

```dart
SearchAppBarPageVariableList<Person>(
  // 1. Implement listVariableFunction (Returns Future<List<T>>)
  listVariableFunction: (query, start, end) async {
    return await MyApiService.searchPersons(query);
  },

  // 2. AppBar Config
  searchAppBarTitle: Text("API Search"),

  // 3. Builder
  obxListBuilder: (context, foundList, isModSearch, index) {
    final person = foundList[index];
    return ListTile(title: Text(person.name));
  },

  // 4. Optional: Handle empty states
  widgetWaiting: CircularProgressIndicator(),
)
```

## Configuration Cheat Sheet

| Parameter                  | Function        | Implication                                                                                                      |
| :------------------------- | :-------------- | :--------------------------------------------------------------------------------------------------------------- |
| **`whereFilter`**          | Filtering logic | **Mandatory** for local lists. Avoid `stringFilter`.                                                             |
| **`listVariableFunction`** | API Search Call | **Mandatory** for `VariableList` widget. Params: (query, start, end).                                            |
| **`onChangedQuery`**       | Query Listener  | Optional. Used to react to query changes without replacing the list logic.                                       |
| **`searchAppBarTitle`**    | AppBar Title    | Replaces standard `title`.                                                                                       |
| **`searchAppBarActions`**  | AppBar Actions  | Replaces standard `actions`.                                                                                     |
| **`onSubmit`**             | Keyboard Enter  | Triggered when typing a search query and pressing Enter. Useful for executing an action on the `highLightIndex`. |
| **`onEnter`**              | Keyboard Enter  | Triggered when no query is typed but Enter is pressed. Has access to `listFull` and `highLightIndex`.            |
| **`obxListBuilder`**       | Custom Builder  | Function signature includes `highlightIndex` which natively tracks up/down arrow key presses on Web/Desktop.     |
