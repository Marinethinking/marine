import 'package:flutter/material.dart';

import 'gridController.dart';

class PagedGrid<T> extends StatelessWidget {
  const PagedGrid(
      {Key? key,
      required this.itemBuilder,
      required this.gridController,
      required this.maxCrossAxisExtent,
      this.childAspectRatio = 1})
      : super(key: key);

  final GridController gridController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double maxCrossAxisExtent;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List>(
      valueListenable: gridController.items,
      builder: (context, value, child) {
        return SliverGrid.extent(
          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: childAspectRatio,
          children: [
            for (int i = 0; i < value.length; i++)
              PagedGridItem(
                heroTag: i + 1,
                gridController: gridController,
                lastBack:
                    i == value.length - 1 ? gridController.fetchPage : null,
                itemBuilder: () {
                  return itemBuilder(context, value[i], i);
                },
              ),
            ValueListenableBuilder(
                valueListenable: gridController.loading,
                builder: (context, value, child) {
                  if (gridController.loading.value) {
                    return Center(
                      child: Builder(builder: (context) {
                        return const CircularProgressIndicator.adaptive();
                      }),
                    );
                  } else if (gridController.items.value.isEmpty) {
                    return const Center(
                      child: Text("No item found."),
                    );
                  }
                  return Container();
                }),
          ],
        );
      },
    );
  }
}

class PagedGridItem extends StatelessWidget {
  final Object? heroTag;
  final Widget? child;
  final Widget Function() itemBuilder;
  final Function()? lastBack;
  final GridController gridController;
  const PagedGridItem({
    Key? key,
    this.heroTag,
    this.child,
    required this.itemBuilder,
    this.lastBack,
    required this.gridController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (lastBack != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        lastBack!();
      });
    }

    return Hero(
        tag: heroTag ?? UniqueKey(),
        child: ValueListenableBuilder(
            valueListenable: gridController.animatedIndex,
            builder: (context, value, child) {
              bool isAnimated = gridController.animatedIndex.value == heroTag;
              bool isReverseAnimated =
                  gridController.animatedIndex.value == -(heroTag as num);
              Widget kid = itemBuilder();
              if (isAnimated) {
                return animatedItem(kid: kid, reverse: false);
              } else if (isReverseAnimated) {
                return animatedItem(kid: kid, reverse: true);
              }
              return kid;
            }));
  }

  Widget animatedItem({required Widget kid, bool reverse = false}) {
    return TweenAnimationBuilder<double>(
      child: kid,
      duration: gridController.duration!,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: reverse ? (1 - value) : value,
          child: kid,
        );
      },
    );
  }
}
