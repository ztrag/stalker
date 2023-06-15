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
  final bool withActivity;

  const UserIconWidget({
    Key? key,
    required this.user,
    this.errorWidget,
    this.image,
    this.size = UserIconSize.medium,
    this.withActivity = true,
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
                      builder: (_, props, __) => AnimatedBuilder(
                        animation: UserIconProvider(),
                        builder: (_, child) => FutureBuilder<Image?>(
                          future: UserIconProvider().fetch(props),
                          builder: (_, snapshot) => ColorFiltered(
                            colorFilter: _getMatrix(props.grayScale),
                            child: Opacity(
                              opacity: props.opacity,
                              child: snapshot.data ?? _errorWidget,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (widget.withActivity) Positioned(
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

  ColorFilter _getMatrix(double grayscale) {
    const identityMatrix = <double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
    const grayMatrix = <double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
    return ColorFilter.matrix(
      grayscale <= 0
          ? identityMatrix
          : (grayscale >= 1
              ? grayMatrix
              : (List<double>.generate(
                  identityMatrix.length,
                  (i) =>
                      identityMatrix[i] * (1 - grayscale) +
                      grayMatrix[i] * grayscale))),
    );
  }
}
