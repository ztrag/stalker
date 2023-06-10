import 'package:flutter/foundation.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/ticker/ticker.dart';
import 'package:stalker/user/user_icon_provider.dart';

class UserLastSeenImageNotifier extends ValueNotifier<UserIconProps> {
  final User user;
  final UserIconSize size;

  late final ValueNotifier<DateTime?> event =
      ValueNotifier(user.lastLocationTimestamp);

  late final Ticker<UserIconProps> _ticker = Ticker(event, [
    TickerThreshold(
      time: const Duration(seconds: 10),
      builder: (t) => UserIconProps(user: user, size: size),
    ),
    TickerThreshold(
      time: const Duration(seconds: 60),
      builder: (t) => UserIconProps(user: user, size: size, grayScale: true),
    ),
  ]);

  UserLastSeenImageNotifier({
    required this.user,
    required this.size,
  }) : super(UserIconProps(user: user, size: size)) {
    _ticker.addListener(_onTick);
    _onTick();
  }

  @override
  void dispose() {
    _ticker.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() async {
    value = _ticker.value ?? UserIconProps(user: user, size: size);
  }
}
