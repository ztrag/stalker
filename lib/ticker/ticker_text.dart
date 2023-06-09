import 'package:flutter/widgets.dart';
import 'package:stalker/ticker/ticker.dart';

typedef DurationToString = String Function(Duration timeSinceEvent);

final List<TickerThreshold<String>> _kTickerThresholds = [
  TickerThreshold(
    time: const Duration(seconds: 10),
    builder: (t) => t == null ? '' : 'now',
  ),
  TickerThreshold(
    time: const Duration(minutes: 1),
    builder: (t) => '<1m',
  ),
  TickerThreshold(
    time: const Duration(hours: 1),
    period: const Duration(minutes: 1),
    builder: (t) => '${t!.inMinutes}m',
  ),
  TickerThreshold(
    time: const Duration(days: 1),
    period: const Duration(hours: 1),
    builder: (t) => '${t!.inHours}h',
  ),
  TickerThreshold(
    time: const Duration(days: 7),
    builder: (t) => '${t!.inDays}d',
  ),
  TickerThreshold(
    time: const Duration(days: 365),
    builder: (t) => '${t!.inDays / 7}w',
  ),
  TickerThreshold(
    time: const Duration(days: 99999999),
    builder: (t) => '${t!.inDays / 365}y',
  ),
];

class TickerText extends StatefulWidget {
  final DateTime? event;
  final TextStyle? style;
  final bool includeSuffix;
  final double? textScaleFactor;

  const TickerText({
    Key? key,
    required this.event,
    this.style,
    this.includeSuffix = false,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  State<TickerText> createState() => _TickerTextState();
}

class _TickerTextState extends State<TickerText> {
  late final ValueNotifier<DateTime?> event = ValueNotifier(widget.event);
  late final Ticker<String> ticker = Ticker(event, _kTickerThresholds);

  @override
  void didUpdateWidget(covariant TickerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    event.value = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ticker,
      builder: (_, text, ___) => (text?.isNotEmpty ?? false)
          ? Text(
              '$text${widget.includeSuffix && text != 'now' ? ' ago' : ''}',
              style: widget.style,
              textScaleFactor: widget.textScaleFactor,
            )
          : Wrap(),
    );
  }
}
