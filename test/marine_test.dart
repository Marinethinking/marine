import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:marine/marine.dart';

void main() {
  test('adds one to input values', () {
    final pagedGrid = PagedGrid(
      gridController: GridController(
        pageFetcher: () async {
          return [];
        },
      ),
      itemBuilder: (BuildContext context, item, int index) {
        return Container();
      },
      maxCrossAxisExtent: 200,
    );
  });
}
