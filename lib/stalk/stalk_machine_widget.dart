import 'package:flutter/widgets.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/stalk/stalk_machine.dart';

class StalkMachineWidget extends StatefulWidget {
  final StalkTarget stalkTarget;
  final Widget child;

  const StalkMachineWidget(
      {Key? key, required this.stalkTarget, required this.child})
      : super(key: key);

  @override
  State<StalkMachineWidget> createState() => _StalkMachineWidgetState();
}

class _StalkMachineWidgetState extends State<StalkMachineWidget> {
  late final StalkMachine stalkMachine;

  @override
  void initState() {
    super.initState();

    stalkMachine = StalkMachine(widget.stalkTarget);
    stalkMachine.stalk();
  }

  @override
  void dispose() {
    stalkMachine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
