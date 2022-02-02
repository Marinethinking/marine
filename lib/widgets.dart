import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget TextDivider({required Widget child}) {
  return Container(
    alignment: Alignment.center,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          thickness: 2,
        ),
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: const Color.fromRGBO(249, 248, 244, 1),
            child: child)
      ],
    ),
  );
}
