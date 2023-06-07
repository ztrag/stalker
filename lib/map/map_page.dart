import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/map/map_styles.dart';
import 'package:stalker/stalk/stalk_machine.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_icon_widget.dart';

class MapPage extends StatefulWidget {
  final User user;

  const MapPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final StalkMachine stalkMachine = StalkMachine(widget.user);
  late LiveData<User> liveUser = LiveData(widget.user);
  final Map<Id, Uint8List> cachedImages = <Id, Uint8List>{};
  bool opacityLoaderPingPong = true;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    _fetchIcons();
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

  void _fetchIcons() async {
    await _fetchIconForUser(ActiveUser().value!);
    await _fetchIconForUser(widget.user);
    setState(() {});
  }

  Future<void> _fetchIconForUser(User user) async {
    final result = await UserIconProvider().fetch(user);
    if (result != null) {
      cachedImages[user.id] = result;
    }
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
                onMapCreated: (controller) {
                  mapController = controller;
                  controller.setMapStyle(
                      Theme.of(context).brightness == Brightness.dark
                          ? kDarkMap
                          : kLightMap);
                },
                markers: _getUsersForMarkers()
                    .map((e) => Marker(
                          markerId: MarkerId('${e.id}'),
                          position: LatLng(
                            e.lastLocationLatitude!,
                            e.lastLocationLongitude!,
                          ),
                          anchor: const Offset(0.5, 0.5),
                          icon: BitmapDescriptor.fromBytes(cachedImages[e.id]!),
                        ))
                    .toSet(),
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _latLngFromUser(liveUser.value ?? User()),
                  zoom: 16,
                ),
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [widget.user, ActiveUser().value!]
                      .map(
                        (e) => IconButton(
                          onPressed: () {
                            mapController?.moveCamera(
                                CameraUpdate.newLatLng(_latLngFromUser(e)));
                          },
                          icon: SizedBox(
                            width: 30,
                            height: 30,
                            child: UserIconWidget(user: e),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 4),
            ValueListenableBuilder(
              valueListenable: stalkMachine.isAvailable,
              builder: (_, isAvailable, ___) => AnimatedOpacity(
                opacity: isAvailable
                    ? 1
                    : opacityLoaderPingPong
                        ? 0.5
                        : 0.25,
                onEnd: () {
                  if (!stalkMachine.isAvailable.value) {
                    setState(() {
                      opacityLoaderPingPong = !opacityLoaderPingPong;
                    });
                  }
                },
                duration: isAvailable
                    ? const Duration(milliseconds: 250)
                    : const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: FloatingActionButton(
                  onPressed: () {
                    if (stalkMachine.isAvailable.value) {
                      stalkMachine.stalk();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset('assets/images/eye-left-fuzz.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            stalkMachine.hasSent,
                            stalkMachine.hasReceivedAck,
                            stalkMachine.hasReceivedLocation,
                          ]),
                          builder: (_, __) => _getStalkStateIcon(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStalkStateIcon() {
    if (stalkMachine.history.value.isEmpty) {
      return Container();
    }
    if (!stalkMachine.hasSent.value) {
      return const Icon(Icons.circle_outlined, size: 3);
    }
    if (!stalkMachine.hasReceivedAck.value) {
      return const Icon(Icons.circle, size: 3);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle, size: 3),
        const SizedBox(width: 2),
        Icon(
          stalkMachine.hasReceivedLocation.value
              ? Icons.circle
              : Icons.circle_outlined,
          size: 4,
        ),
      ],
    );
  }

  List<User> _getUsersForMarkers() {
    final target = liveUser.value!;
    final stalker = ActiveUser().value!;
    return [
      if (cachedImages[target.id] != null && target.hasLocation) target,
      if (cachedImages[stalker.id] != null && stalker.hasLocation) stalker,
    ];
  }
}

LatLng _latLngFromUser(User user) {
  return LatLng(
    user.lastLocationLatitude ?? 45.529203417794825,
    user.lastLocationLongitude ?? -122.69094861252296,
  );
}
