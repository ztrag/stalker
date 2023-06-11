import 'package:flutter/foundation.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/ticker/ticker.dart';
import 'package:stalker/user/user_icon_provider.dart';

class UserLastSeenImageNotifier extends ValueNotifier<UserIconProps> {
  final User user;
  final UserIconSize size;
  final double baseOpacity;

  late final ValueNotifier<DateTime?> event =
      ValueNotifier(user.lastLocationTimestamp);

  late final Ticker<UserIconProps> _ticker = Ticker(event, [
    TickerThreshold(
      time: const Duration(seconds: 10),
      builder: (t) =>
          UserIconProps(user: user, size: size, opacity: baseOpacity),
    ),
    TickerThreshold(
      time: const Duration(minutes: 2),
      builder: (t) => UserIconProps(
          user: user, size: size, grayScale: 0.4, opacity: 0.8 * baseOpacity),
    ),
    TickerThreshold(
      time: const Duration(minutes: 5),
      builder: (t) => UserIconProps(
          user: user, size: size, grayScale: 0.7, opacity: 0.75 * baseOpacity),
    ),
    TickerThreshold(
      time: const Duration(days: 365000),
      builder: (t) => UserIconProps(
          user: user, size: size, grayScale: 1, opacity: 0.75 * baseOpacity),
    ),
  ]);

  UserLastSeenImageNotifier({
    required this.user,
    required this.size,
    this.baseOpacity = 1,
  }) : super(UserIconProps(user: user, size: size)) {
    _ticker.addListener(_onTick);
    _onTick();
  }

  @override
  void dispose() {
    _ticker.removeListener(_onTick);
    _ticker.dispose();
    super.dispose();
  }

  void _onTick() async {
    value = _ticker.value ?? UserIconProps(user: user, size: size);
  }
}
