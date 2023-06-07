import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/stalk/stalk_machine.dart';
import 'package:stalker/user/user_icon_provider.dart';

class MapPage extends StatefulWidget {
  final User user;

  const MapPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final StalkMachine stalkMachine = StalkMachine(widget.user);
  late LiveData<User> liveUser = LiveData(widget.user);
  Uint8List? targetIconBytes;
  bool _opacityLoaderPingPong = true;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    _fetchTargetIcon();
  }

  @override
  void dispose() {
    liveUser.dispose();
    stalkMachine.dispose();
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
      builder: (_, __) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                zoomControlsEnabled: false,
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    liveUser.value?.lastLocationLatitude ?? 45.529203417794825,
                    liveUser.value?.lastLocationLongitude ??
                        -122.69094861252296,
                  ),
                  zoom: 16,
                ),
              ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: onStalkRequested,
        //     child: const Icon(Icons.remove_red_eye_outlined)),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: stalkMachine.isAvailable,
          builder: (_, isAvailable, ___) => AnimatedOpacity(
            opacity: isAvailable
                ? 1
                : _opacityLoaderPingPong
                    ? 0.5
                    : 0.25,
            onEnd: () {
              if (!stalkMachine.isAvailable.value) {
                setState(() {
                  _opacityLoaderPingPong = !_opacityLoaderPingPong;
                });
              }
            },
            duration: isAvailable
                ? const Duration(milliseconds: 250)
                : const Duration(seconds: 1),
            child: FloatingActionButton(
              onPressed: () {
                if (stalkMachine.isAvailable.value) {
                  stalkMachine.stalk();
                }
              },
              child: isAvailable
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : AnimatedBuilder(
                      animation: Listenable.merge([
                        stalkMachine.hasSent,
                        stalkMachine.hasReceivedAck,
                        stalkMachine.hasReceivedLocation,
                      ]),
                      builder: (_, __) => _getStalkStateIcon(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStalkStateIcon() {
    if (!stalkMachine.hasSent.value) {
      return const Icon(Icons.circle_outlined, size: 10);
    }
    if (!stalkMachine.hasReceivedAck.value) {
      return const Icon(Icons.circle, size: 10);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle, size: 10),
        const SizedBox(width: 2),
        Icon(
          stalkMachine.hasReceivedLocation.value
              ? Icons.circle
              : Icons.circle_outlined,
          size: 10,
        ),
      ],
    );
  }
}
