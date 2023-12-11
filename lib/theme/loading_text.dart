import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stalker/alien/alien_encription.dart';

const String kLoadingChars =
    '─━╾╼+~∘∙─━╾╼+~∘∙─━╾╼+~∘∙─━╾╼+~∘∙─━╾╼+~∘∙─━╾╼+~∘∙─━╾╼+~∘∙'
    '$kAlienChars';

final Random _kRandom = Random();

class LoadingText extends StatelessWidget {
  final int length;

  const LoadingText({Key? key, this.length = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      List.generate(
        length,
        (index) => kLoadingChars[_kRandom.nextInt(kLoadingChars.length)],
      ).join(),
      overflow: TextOverflow.clip,
      textScaler: const TextScaler.linear(0.6),
      style: Theme.of(context).textTheme.bodySmall!,
    );
  }
}
