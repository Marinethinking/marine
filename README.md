<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This is an animated grid view with pagination.  Implemented by SliverGrid.
If you need an animated list view please check in flutter.  
Or if you need an animated list view with pagination you can easy to give your grid item a large with to make it a list.

Flutter doesn't have an animated GridView, when you add or remove an element from a grid,
it is hard to know where you added or removed.

## Features

1. Animated sliver Grid view.
2. Pagination, scroll down to fetch new page.
3. Easy to pop a widget from inside a grid or return it back.

## Usage

```dart
    GridController gridController = GridController(pageFetcher: fetchList);
    PagedGrid(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.8,
        gridController: gridController,
        itemBuilder: (ctxt, item, index) {
          Widget row = itemView(index: index, data: item);
          return row;
        });
```

![alt](https://github.com/Marinethinking/marine/doc/pagedGrid.gif)