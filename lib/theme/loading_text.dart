import 'dart:math';

import 'package:flutter/material.dart';

const String _kChars = '_+-|_-----~~~~~~~___....=.';
final Random _kRandom = Random();

class LoadingText extends StatelessWidget {
  final int length;

  const LoadingText({Key? key, this.length = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      List.generate(length, (index) {
        int i = _kRandom.nextInt(_kChars.length);
        return _kChars.substring(i, i + 1);
      }).join(),
      overflow: TextOverflow.clip,
      textScaleFactor: 0.6,
      style: Theme.of(context).textTheme.bodySmall!,
    );
  }
}
