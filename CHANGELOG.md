## [1.2.1]
- Minor corrections.

## [1.2.0]
- Now you can build it without AppBar by placing the body of your list wherever you want.

## [1.1.0]
- There is no more need to pass the function to make a sort compare on the list. 
Just pass compare = false to not organize your list.

## [1.0.3]
- Improved setState in [SearchAppBarPage].

## [1.0.2]
- Minor corrections.

## [1.0.1+1]
- Update to the newest version of Flutter and the dependencies used in the package.

## [1.0.1]
- Now you can setState with initialData with number of non-multiple elements in numItemsPage without problems.

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
- Improvements to [SearchAppBarPagination]. I now require two pages of the API when the current 
page is incomplete and is filtering through Search.

## [0.3.0+1]
- Just improving the doc and readme.

## [0.3.0]
- In this new update (SearchAppBarPagination - 🙌🏽 ) was added and some fixes were added.

## [0.2.2]
- Fixed when using null initialList (SearchAppBarPageStream) and making a setState in the initialList 
not null.

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
data request. Appears when there is no data and the connection is disconnected. By default, there is 
also a status icon on the application bar. You can change the color, type or not show.

## [0.0.2]
- Corrections in reading and example.

## [0.0.1]
- Initial release.


