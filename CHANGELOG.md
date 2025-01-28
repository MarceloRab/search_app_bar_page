## [3.0.0-release.5]

- see [2.4.2] below.

## [3.0.0-release.4]

- see [2.4.2] below.

## [3.0.0-release.3]

- Add [whereFilter] - see below [2.4.2]

## [3.0.0-release.1]

- Adapting to get package 5.0.0

## [3.0.0-release.2]

- Adapting to get package 5.0.0

## [3.0.0-release.1]

- Adapting to get package 5.0.0

## [2.5.0]

- Now you can use the 'esc' key to exit and the 'enter' key to return from [onSubmitted] in SearchAppBarPage. Fixed animation on larger screens like Flutter Web.

## [2.4.2]

- Add [whereFilter] Required if you want to make your own function to delete components from
  your list. If you don't want to use a String from your Object, pass it directly to a function
  to delete an item from your list.
  ex.: whereFilter: (Person person, Sring? query) => bool return - used to
  filter dates by the largest String,

## [2.4.1]

- Same as before

## [2.4.0]

- Update get Package 5.0 and >. Crash on previous version. Go back to v. 2.3.1 to use get package 4.6.6 or lower than 5.0

## [2.3.3]

- Corrections

## [2.3.2]

- Updating

## [2.3.1]

- Fixed words Spell Checker

## [2.3.0]

- Fixed if [stringFilter] presents a null value

## [2.2.1]

- Update Min SDK

## [2.2.0]

- Removal of connectivity check

## [2.1.3]

- New Flutter Version

## [2.1.2]

- Minimal improvement

## [2.1.1]

- Fix to change sortFunction to reset SearchAppBarPage after setState.

## [2.1.0]

- By request. Added option to add filtering function manually.
  Removes the need to return a String. May generate exception if the user
  types a letter and the dev wants to filter by the number. In this case,
  you need to handle the exception within the manual filtering function.
  New parameter for = > SearchAppBarPageStream and = > SearchAppBarPage is `[filter]`.
- Now the dev can add its own sorting function `[sortFunction]`.
  By default sorting is done from the return of `[stringFilter]`.
- See example

## [2.0.7]

- Minimal improvement in the example

## [2.0.6]

- Correction in readme log.

## [2.0.5]

- Fixing error for connection check.

## [2.0.4]

- Minimal improvement

## [2.0.3]

- Updated dependences.

## [2.0.2]

- Updated packages.

## [2.0.1]

- Updated packages.

## [2.0.0]

- Now all packages are in nullsafety!

## [2.0.0-nullsafety.17]

- One More Minimal improvement nullsafety. 🙈

## [2.0.0-nullsafety.16]

- Minimal improvement nullsafety.

## [2.0.0-nullsafety.15]

- Minimal improvement SearchAppBarPagination nullsafety.

## [2.0.0-nullsafety.14]

- Minimal improvement nullsafety.

## [2.0.0-nullsafety.13]

- Fix in SearchAppBarPage.

## [2.0.0-nullsafety.12]

- Minimal improvement flutter web. Need to maintain Search status on larger screens.

## [2.0.0-nullsafety.11]

- Minimal improvement nullsafety.

## [2.0.0-nullsafety.10]

- Minimal improvement extensions.

## [2.0.0-nullsafety.9]

- Now you can assemble a Widget from RxString, RxInt, RxDouble, RxNumber and RxList. With the
  `[getStreamWidget]` extension. It turns your Rx variable into a `[GetStreamWidget]`. If
  there is nothing in the stream, it starts the wait. When you add something, it launches
  obxBuilder. If there is an error, it starts the ErrorWidget. Ready to use.

## [2.0.0-nullsafety.8]

- The StreamSubscription were all getting canceled. However, why add repeated lines of
  \_subscription?.cancel() stops generating warning.

## [2.0.0-nullsafety.7]

- Minimal improvement.

## [2.0.0-nullsafety.6]

- Small improvement.

## [2.0.0-nullsafety.5]

- Added `[SearchAppBarRefresh]`. Now you can request data from your API and manually renew your
  requirements.

## [2.0.0-nullsafety.4]

- Small improvement in nullsafety.

## [2.0.0-nullsafety.3]

- Small improvement in Flutter 2.0.

## [2.0.0-nullsafety.2]

- Null-Safety initial

## [1.6.0]

- Added `[GertStreamPage]` and `[GetStreamWidget]` merging another package to make life
  easier for the developer. Updated packages in use. Waiting for this package to update to
  null-safe.

## [1.5.1]

- Small improvement.

## [1.5.0]

- Update packages. Need to change from get_state_manager to get. The get_state_manager package has
  been deprecated.

## [1.4.2]

- Only improvements in the presentation of exceptions.

## [1.4.1]

- Now the builders methods have been changed to obxBuilders, as they can receive Rx variables to
  reconstruct the screens.

## [1.4.0+1]

- Testing SearchAppBarPagination with a real API. See complete example.

## [1.3.3]

- Corrections in didUpdateWidget for setState.

## [1.3.2]

- Minor corrections.

## [1.3.1+1]

- Correction in the readme. One more time.

## [1.3.0]

- Learned the creative way to add bool parameter of auth to your page. configures `[rxBoolAuth]`
  .
- To add other Rx parameters, just configure them within the `[obxListBuilder]` function in
  SearchAppBarPage and SearchAppBarPageStream. See complete example for details. So your page will
  be complete.
- Before it was `[listBuilder]` now `[obxListBuilder]` because this function can receive Rx
  variables for reactivity.

## [1.2.1]

- Minor corrections.

## [1.2.0]

- Now you can build it without AppBar by placing the body of your list wherever you want.

## [1.1.0]

- There is no more need to add the function to make a sort compare on the list. Just add compare =
  false to not organize your list.

## [1.0.3]

- Improved setState in [SearchAppBarPage].

## [1.0.2]

- Minor corrections.

## [1.0.1+1]

- Update to the newest version of Flutter and the dependencies used in the package.

## [1.0.1]

- Now you can setState with initialData with number of non-multiple elements in numItemsPage without
  problems.

## [1.0.0]

- Various improvements. The search engine at [SearchAppBarPagination] has been modified to minimize
  API requests to the maximum. Name changes to improve syntax.

## [0.3.7]

- Some more fixes in [SearchAppBarPagination].

## [0.3.6]

- Improving the code to decrease the need for setState with get_state_manager. Necessary corrections
  were made. You can now change the type of filtering and give it a setState. Added code if the
  request values return null.

## [0.3.5]

- Reformulation in error handling of [futureFetchPageItems] and [listStream] in
  [SearchAppBarPagination] and [SearchAppBarPageStream] respectively. Now you can handle it if the
  error is SocketException, HttpException, DioError and others like Firebase Exceptions.

## [0.3.4]

- Changes to clear code and fixes in [SearchAppBarPagination] in search mode. Added @immutable to
  the AsyncSnapshotScrollPage class.

## [0.3.3]

- Corrections in [SearchAppBarPagination]. After doing setState and redoing the list filtered by
  youthe search.

## [0.3.2]

- Ensure that you require 02 pages only when they are at the end of the page and scroll.

## [0.3.1]

- Improvements to [SearchAppBarPagination]. I now require two pages of the API when the current page
  is incomplete and is filtering through Search.

## [0.3.0+1]

- Just improving the doc and readme.

## [0.3.0]

- In this new update (SearchAppBarPagination - 🙌🏽 ) was added and some fixes were added.

## [0.2.2]

- Fixed when using null initialList (SearchAppBarPageStream) and making a setState in the
  initialList not null.

## [0.2.1]

- Correction in changing [widgetOffConnectyWaiting] and [widgetWaiting]. Correction to intialList
  within Stream <List> and Internet Connection. Readme and documentation improvements.

## [0.2.0]

- Change in the connection verification method. The default language is now English with Portuguese
  translation.

## [0.1.1]

- Improved performance. Classes have now become constant and the need for streams has decreased.

## [0.1.0]

- You can now use your SearchAppBarPageStream on a StatefulWidget and setState.
- I added a mechanism to verify the connection and it shows a widget [widgetConnecty] in the first
  data request. Appears when there is no data and the connection is disconnected. By default, there
  is also a status icon on the application bar. You can change the color, type or not show.

## [0.0.2]

- Corrections in reading and example.

## [0.0.1]

- Initial release.
