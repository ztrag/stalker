import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/user_activity_widget.dart';
import 'package:stalker/user/user_icon_provider.dart';

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
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _fetch();
    UserIconProvider().addListener(_fetch);
  }

  @override
  void dispose() {
    UserIconProvider().removeListener(_fetch);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UserIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _fetch();
    }
  }

  void _fetch() async {
    _image = widget.image ??
        await UserIconProvider().fetch(widget.user, widget.size);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _iconImage),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: UserActivityWidget(user: widget.user),
        ),
      ],
    );
  }

  Widget get _iconImage {
    return _image != null
        ? Image.memory(
            _image!,
            errorBuilder: (_, __, ___) => _errorWidget,
          )
        : _errorWidget;
  }

  Widget get _errorWidget {
    return widget.errorWidget ?? const Icon(Icons.image_not_supported_outlined);
  }
}
