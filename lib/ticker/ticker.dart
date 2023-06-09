import 'package:flutter/foundation.dart';

typedef TimedBuilder<T> = T Function(Duration? timeElapsed);

class TickerThreshold<T> {
  final Duration time;
  final Duration? period;
  final TimedBuilder<T> builder;

  const TickerThreshold({
    required this.time,
    this.period,
    required this.builder,
  });
}

class Ticker<T> extends ValueNotifier<T?> {
  final ValueListenable<DateTime?> event;
  final List<TickerThreshold<T>> thresholds;
  int _tickCounter = 0;

  Ticker(this.event, this.thresholds) : super(null) {
    event.addListener(_tick);
    _tick();
  }

  @override
  void dispose() {
    event.removeListener(_tick);
    super.dispose();
  }

  void _tick() {
    _tickCounter++;
    final checkTickCounter = _tickCounter;
    final eventTime = event.value;

    final timeSinceEvent =
        eventTime == null ? null : DateTime.now().difference(eventTime);
    final threshold = _getThreshold(eventTime, thresholds);
    value = threshold.builder(timeSinceEvent);

    if (timeSinceEvent == null) {
      return;
    }

    final timeForNextThreshold = threshold.time - timeSinceEvent;
    final timeForNextPeriod = _getTimeForNextPeriod(threshold, timeSinceEvent);
    final nextDelay =
        (timeForNextPeriod != null && timeForNextPeriod < timeForNextThreshold)
            ? timeForNextPeriod
            : timeForNextThreshold;

    if (nextDelay.inMilliseconds < 0) {
      return;
    }
    Future.delayed(nextDelay, () {
      if (checkTickCounter == _tickCounter) {
        _tick();
      }
    });
  }

  Duration? _getTimeForNextPeriod(
      TickerThreshold<T> current, Duration timeSinceEvent) {
    if (current.period == null) {
      return null;
    }

    final thresholdIndex = thresholds.indexOf(current);
    final prevThresholdTime = thresholdIndex == 0
        ? const Duration()
        : thresholds[thresholdIndex - 1].time;
    final exceededOverPrev = timeSinceEvent - prevThresholdTime;
    final periodsElapsed =
        exceededOverPrev.inMilliseconds ~/ current.period!.inMilliseconds;
    return (prevThresholdTime + current.period! * (periodsElapsed + 1)) -
        timeSinceEvent;
  }

  static TickerThreshold<T> _getThreshold<T>(
    DateTime? event,
    List<TickerThreshold<T>> thresholds,
  ) {
    if (event == null) {
      return thresholds.first;
    }

    final timeSinceEvent = DateTime.now().difference(event);

    for (final threshold in thresholds) {
      if (timeSinceEvent < threshold.time) {
        return threshold;
      }
    }
    return thresholds.last;
  }
}
