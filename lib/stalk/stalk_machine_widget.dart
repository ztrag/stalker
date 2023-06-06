import 'package:flutter/widgets.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/stalk/stalk_machine.dart';

class StalkMachineWidget extends StatefulWidget {
  final User target;
  final Widget child;

  const StalkMachineWidget(
      {Key? key, required this.target, required this.child})
      : super(key: key);

  @override
  State<StalkMachineWidget> createState() => _StalkMachineWidgetState();
}

class _StalkMachineWidgetState extends State<StalkMachineWidget> {
  late final StalkMachine stalkMachine;

  @override
  void initState() {
    super.initState();

    stalkMachine = StalkMachine(widget.target);
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
