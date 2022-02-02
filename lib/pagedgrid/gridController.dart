import 'package:flutter/material.dart';

typedef PageBuilder = List<Widget> Function(int length);

class GridController<T> {
  GridController({required this.pageFetcher, this.duration}) {
    if (duration == null) this.duration = Duration(seconds: 1);
  }
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<List> items = ValueNotifier<List>([]);
  final ValueNotifier<int> animatedIndex = ValueNotifier(0);
  final Future<List> Function() pageFetcher;
  Duration? duration;

  dispose() {
    loading.dispose();
    items.dispose();
    animatedIndex.dispose();
  }

  refresh() {
    items.value.clear();
    fetchPage();
    items.notifyListeners();
  }

  addItems(List itemList) {
    items.value = items.value + itemList;
  }

  addItem(item) {
    animatedIndex.value = 1;
    items.value = [item] + items.value;

    Future.delayed(duration!, () {
      animatedIndex.value = 0;
    });
  }

  fetchPage() async {
    loading.value = true;
    // await Future.delayed(Duration(seconds: 1));
    List page = await pageFetcher();
    if (page.isNotEmpty) addItems(page);
    loading.value = false;
  }

  tagOfItem({required T data, bool Function(T t1, T t2)? comparator}) {
    int tag = -1;
    if (comparator == null) {
      if (items.value.any((element) => element == data)) {
        tag = items.value.indexOf(data);
        tag += 1;
      }
    } else {
      if (items.value.any((element) => comparator(element, data))) {
        tag = items.value.indexWhere((element) => comparator(element, data));
        tag += 1;
      }
    }

    return tag;
  }

  showItem(
      {required Widget item,
      required BuildContext context,
      required T data,
      bool Function(T t1, T t2)? comparator}) {
    int tag = tagOfItem(data: data, comparator: comparator);

    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black26.withOpacity(0.6),
        pageBuilder: (BuildContext context, _, __) {
          return Container(
              alignment: Alignment.center,
              child: Hero(tag: tag, child: FittedBox(child: item)));
        }));
  }

  deleteItem({required T data, bool Function(T t1, T t2)? comparator}) {
    int tag = tagOfItem(data: data, comparator: comparator);
    if (tag < 1) return;
    animatedIndex.value = -tag;
    Future.delayed(duration!, () {
      animatedIndex.value = 0;
      items.value.removeAt(tag - 1);
      items.notifyListeners();
      print(items.value[0]);
    });
  }
}
