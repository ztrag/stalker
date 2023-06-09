import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/has_id.dart';
import 'package:stalker/live/live_data.dart';

class LiveDataBuilder<T extends HasId> extends StatefulWidget {
  final T initial;
  final Function(Isar db, LiveData<T> data) prepare;
  final Widget Function(T? data) builder;

  const LiveDataBuilder({
    Key? key,
    required this.initial,
    required this.prepare,
    required this.builder,
  }) : super(key: key);

  @override
  State<LiveDataBuilder<T>> createState() => _LiveDataBuilderState<T>();
}

class _LiveDataBuilderState<T extends HasId> extends State<LiveDataBuilder<T>> {
  late LiveData<T> liveData = _prepare();

  @override
  void didUpdateWidget(covariant LiveDataBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (liveData.value?.id != widget.initial.id) {
      liveData.dispose();
      liveData = _prepare();
    }
  }

  LiveData<T> _prepare() {
    final liveData = LiveData<T>(widget.initial);
    Db.db.then((db) => widget.prepare(db, liveData));
    return liveData;
  }

  @override
  void dispose() {
    liveData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: liveData,
      builder: (_, __, ___) => widget.builder(liveData.value),
    );
  }
}
