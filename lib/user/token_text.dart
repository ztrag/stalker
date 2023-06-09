import 'package:flutter/material.dart';
import 'package:stalker/alien/alien_encription.dart';
import 'package:stalker/domain/user.dart';

class TokenText extends StatelessWidget {
  final User user;
  final int? maxLines;
  final double textScaleFactor;

  const TokenText({
    Key? key,
    required this.user,
    this.maxLines,
    this.textScaleFactor = 0.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      (user.token ?? 'null').encrypt,
      style: Theme.of(context).textTheme.labelSmall,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
    );
  }
}
