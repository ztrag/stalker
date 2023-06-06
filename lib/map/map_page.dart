import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/stalk/stalk_machine_widget.dart';
import 'package:stalker/user/user_icon_provider.dart';

class MapPage extends StatefulWidget {
  final User user;

  const MapPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LiveData<User> liveUser = LiveData(widget.user);
  Uint8List? targetIconBytes;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    _fetchTargetIcon();
  }

  @override
  void dispose() {
    liveUser.dispose();
    super.dispose();
  }

  void _monitorTarget() async {
    final db = await Db.db;
    liveUser.inCollection(db.users);
  }

  void _fetchTargetIcon() async {
    targetIconBytes = await UserIconProvider().fetch(widget.user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: liveUser,
      builder: (_, __) => StalkMachineWidget(
        target: widget.user,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.displayName),
          ),
          body: Platform.isIOS
              ? Container()
              : GoogleMap(
                  markers: {
                    if (targetIconBytes != null && liveUser.value!.hasLocation)
                      Marker(
                        markerId: MarkerId('${widget.user.id}'),
                        position: LatLng(
                          liveUser.value!.lastLocationLatitude!,
                          liveUser.value!.lastLocationLongitude!,
                        ),
                        icon: BitmapDescriptor.fromBytes(targetIconBytes!),
                      ),
                  },
                  mapType: MapType.satellite,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      liveUser.value?.lastLocationLatitude ??
                          45.529203417794825,
                      liveUser.value?.lastLocationLongitude ??
                          -122.69094861252296,
                    ),
                    zoom: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
