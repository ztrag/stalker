import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/user_icon_provider.dart';

class UserIconWidget extends StatefulWidget {
  final User user;
  final Widget? errorWidget;

  const UserIconWidget({Key? key, required this.user, this.errorWidget})
      : super(key: key);

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

  void _fetch() async {
    _image = await UserIconProvider().fetch(widget.user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UserIconProvider(),
      builder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: _image != null
              ? Image.memory(_image!, errorBuilder: (c, _, __) => _errorWidget)
              : _errorWidget),
    );
  }

  Widget get _errorWidget {
    return widget.errorWidget ?? const Icon(Icons.image_not_supported_outlined);
  }
}
