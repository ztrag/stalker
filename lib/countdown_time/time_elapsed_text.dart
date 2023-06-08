import 'package:flutter/widgets.dart';

typedef DurationToString = String Function(Duration timeSinceEvent);

final Map<Duration, DurationToString> _kThresholds = {
  const Duration(seconds: 10): (t) => '<1m',
  const Duration(minutes: 1): (t) => '${t.inMinutes}m',
  const Duration(hours: 1): (t) => '${t.inHours}h',
  const Duration(days: 1): (t) => '${t.inDays}d',
  const Duration(days: 7): (t) => '${t.inDays / 7}w',
  const Duration(days: 365): (t) => '${t.inDays / 365}y',
};

class TimeElapsedText extends StatefulWidget {
  final DateTime? event;
  final TextStyle? style;
  final bool includeSuffix;

  const TimeElapsedText({
    Key? key,
    required this.event,
    this.style,
    this.includeSuffix = false,
  }) : super(key: key);

  @override
  State<TimeElapsedText> createState() => _TimeElapsedTextState();
}

class _TimeElapsedTextState extends State<TimeElapsedText> {
  final ValueNotifier<String> text = ValueNotifier('');
  int updateCount = 0;

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  void didUpdateWidget(covariant TimeElapsedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event != widget.event) {
      ++updateCount;
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: text,
      builder: (_, __, ___) => Text(text.value, style: widget.style),
    );
  }

  void update() {
    if (widget.event == null) {
      return;
    }
    final checkUpdateCount = updateCount;
    final timeSinceEvent = DateTime.now().difference(widget.event!);
    Duration? lastThreshold;

    for (final threshold in _kThresholds.keys) {
      if (timeSinceEvent < threshold) {
        if (timeSinceEvent < const Duration(seconds: 10)) {
          text.value = 'now';
        } else {
          text.value = '${_kThresholds[lastThreshold]!(timeSinceEvent)}'
              '${widget.includeSuffix ? ' ago' : ''}';
        }

        final jump = _getNextJump(lastThreshold, timeSinceEvent) +
            const Duration(milliseconds: 16);
        Future.delayed(jump, () {
          if (mounted && checkUpdateCount == updateCount) {
            update();
          }
        });
        return;
      }
      lastThreshold = threshold;
    }
  }

  Duration _getNextJump(Duration? period, Duration timeSinceEvent) {
    if (period == null) {
      return _kThresholds.keys.first - timeSinceEvent;
    } else if (period == _kThresholds.keys.first) {
      return const Duration(minutes: 1) - timeSinceEvent;
    }

    final next = timeSinceEvent.inMilliseconds ~/ period.inMilliseconds + 1;
    return period * next - timeSinceEvent;
  }
}
