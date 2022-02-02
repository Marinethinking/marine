import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marine/marine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paged Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Paged Grid Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  late GridController gridController;

  @override
  void initState() {
    super.initState();
    gridController = GridController(pageFetcher: fetchList);
    gridController.fetchPage();
  }

  @override
  void dispose() {
    super.dispose();
    gridController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child:
                  SizedBox(height: 150, child: Text("Paged grid view Example")),
            ),
            SliverToBoxAdapter(
              child: TextDivider(child: const Text('Divider')),
            ),
            pagedGrid,
          ],
        ),
      ),
      floatingActionButton: floatingButton,
    );
  }

  Widget get pagedGrid {
    return PagedGrid(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.8,
        gridController: gridController,
        itemBuilder: (ctxt, item, index) {
          Widget row = itemView(index: index, data: item);
          return row;
        });
  }

  Widget itemView(
      {int index = 0, bool standlone = false, bool isAdd: false, data}) {
    Widget result = Container(
      alignment: Alignment.center,
      width: 200,
      height: 200,
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                const Text("index"),
                const SizedBox(width: 10),
                Text("$index")
              ],
            ),
            Row(
              children: [
                const Text("data"),
                const SizedBox(width: 10),
                Text("${data['data'] ?? 'unk'}")
              ],
            ),
            if (!standlone)
              TextButton.icon(
                  onPressed: () {
                    gridController.showItem(
                        data: data,
                        item:
                            itemView(index: index, standlone: true, data: data),
                        context: context);
                  },
                  icon: const Icon(Icons.more_horiz),
                  label: const Text("DETAIL")),
            if (standlone)
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("BACK")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        gridController.deleteItem(data: data);
                      },
                      child: const Text("DELETE")),
                ],
              ),
            if (isAdd)
              TextButton(
                  onPressed: () {
                    gridController.addItem({"data": "new"});
                    Navigator.pop(context);
                  },
                  child: const Text("ADD")),
          ],
        ),
      ),
    );
    return result;
  }

  Future<List> fetchList() async {
    if (gridController.items.value.length > 100) return [];
    var ran = Random();
    List items = [];
    for (int i = 0; i < 2; i++) {
      Map item = {"data": ran.nextInt(10000)};
      items.add(item);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    return items;
  }

  Widget get floatingButton {
    return Align(
      alignment: const Alignment(1, 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              heroTag: -1,
              onPressed: () {
                gridController.showItem(
                    data: {},
                    item: itemView(
                        index: -1, standlone: true, isAdd: true, data: {}),
                    context: context);
              },
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
              child: const Icon(Icons.arrow_upward),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                gridController.refresh();
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
