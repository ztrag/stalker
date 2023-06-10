import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data_builder.dart';
import 'package:stalker/user/user_activity_widget.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_last_seen_image_notifier.dart';

const double kUserIconSize = 60.0;

class UserIconWidget extends StatefulWidget {
  final User user;
  final Widget? errorWidget;
  final Uint8List? image;
  final UserIconSize size;

  const UserIconWidget({
    Key? key,
    required this.user,
    this.errorWidget,
    this.image,
    this.size = UserIconSize.large,
  }) : super(key: key);

  @override
  State<UserIconWidget> createState() => _UserIconWidgetState();
}

class _UserIconWidgetState extends State<UserIconWidget> {
  late UserLastSeenImageNotifier notifier = UserLastSeenImageNotifier(
    user: widget.user,
    size: widget.size,
  );

  @override
  void didUpdateWidget(covariant UserIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user || widget.size != oldWidget.size) {
      notifier.dispose();
      notifier =
          UserLastSeenImageNotifier(user: widget.user, size: widget.size);
    }
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.image != null
              ? _getIconImage(widget.image)
              : LiveDataBuilder<User>(
                  initial: widget.user,
                  prepare: (db, liveUser) => liveUser.inCollection(db.users),
                  builder: (user) {
                    notifier.event.value = user?.lastLocationTimestamp;
                    return ValueListenableBuilder<UserIconProps>(
                      valueListenable: notifier,
                      builder: (_, props, __) => FutureBuilder<Uint8List?>(
                        future: UserIconProvider().fetch(props),
                        builder: (_, snapshot) => _getIconImage(snapshot.data),
                      ),
                    );
                  },
                ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: UserActivityWidget(user: widget.user),
        ),
      ],
    );
  }

  Widget _getIconImage(Uint8List? image) {
    return image != null
        ? Image.memory(
            image,
            errorBuilder: (_, __, ___) => _errorWidget,
            gaplessPlayback: true,
          )
        : _errorWidget;
  }

  Widget get _errorWidget {
    return widget.errorWidget ?? const Icon(Icons.image_not_supported_outlined);
  }
}
