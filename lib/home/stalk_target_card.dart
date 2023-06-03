import 'package:flutter/widgets.dart';
import 'package:stalker/domain/stalk_target.dart';

class StalkTargetCard extends StatelessWidget {
  final StalkTarget stalkTarget;

  const StalkTargetCard({Key? key, required this.stalkTarget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('${stalkTarget.name}');
  }
}
