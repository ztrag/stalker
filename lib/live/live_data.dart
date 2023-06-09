import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:stalker/domain/has_id.dart';

class LiveData<T extends HasId> extends ValueNotifier<T?> {
  StreamSubscription<T?>? listen;

  LiveData(super.value);

  LiveData inCollection(IsarCollection<T> collection) {
    listen?.cancel();
    listen = collection.watchObject(value!.id).listen((event) {
      value = event;
    });
    return this;
  }

  @override
  void dispose() {
    listen?.cancel();
    super.dispose();
  }
}
