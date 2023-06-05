import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/profile_picture/profile_picture_provider.dart';
import 'package:stalker/stalk/stalk_machine_widget.dart';

class MapPage extends StatefulWidget {
  final StalkTarget stalkTarget;

  const MapPage({Key? key, required this.stalkTarget}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late StreamSubscription<StalkTarget?> targetDbSubscription;
  StalkTarget? updatedTarget;
  Uint8List? targetIconBytes;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    _fechTargetIcon();
  }

  @override
  void dispose() {
    targetDbSubscription.cancel();
    super.dispose();
  }

  void _fechTargetIcon() async {
    targetIconBytes = await ProfilePictureFetcher().fetch(
      widget.stalkTarget.profilePictureUrl!,
    );
    setState(() {});
  }

  void _monitorTarget() async {
    final db = await Db.db;
    targetDbSubscription =
        db.stalkTargets.watchObject(widget.stalkTarget.id).listen((event) {
      setState(() {
        updatedTarget = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = updatedTarget ?? widget.stalkTarget;
    return StalkMachineWidget(
      stalkTarget: widget.stalkTarget,
      child: Scaffold(
        appBar: AppBar(
          title: Text('stalking ${widget.stalkTarget.name ?? ''}'),
        ),
        body: Platform.isIOS || !_hasLocation(t)
            ? Container()
            : GoogleMap(
                markers: {
                  if (targetIconBytes != null)
                    Marker(
                      markerId: MarkerId('${widget.stalkTarget.id}'),
                      position: LatLng(
                        t.lastLocationLatitude!,
                        t.lastLocationLongitude!,
                      ),
                      icon: BitmapDescriptor.fromBytes(targetIconBytes!),
                    ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.stalkTarget.lastLocationLatitude!,
                    widget.stalkTarget.lastLocationLongitude!,
                  ),
                  zoom: 14,
                ),
              ),
      ),
    );
  }

  bool _hasLocation(StalkTarget target) {
    return target.lastLocationLongitude != null &&
        target.lastLocationLatitude != null;
  }
}
