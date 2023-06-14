import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/logger/logger.dart';
import 'package:stalker/map/map_styles.dart';
import 'package:stalker/stalk/stalk_machine.dart';
import 'package:stalker/stalk/stalk_message_hub.dart';
import 'package:stalker/theme/loading_text.dart';
import 'package:stalker/ticker/ticker.dart';
import 'package:stalker/ticker/ticker_text.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_distance_from_stalker.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_icon_widget.dart';
import 'package:stalker/user/user_last_seen_image_notifier.dart';
import 'package:stalker/user/user_time_since_last_location.dart';

class MapPage extends StatefulWidget {
  final User user;

  const MapPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final StalkMachine stalkMachine = StalkMachine(widget.user);

  late LiveData<User> liveUser = LiveData(widget.user);

  final Map<Id, BitmapDescriptor> cachedImages = <Id, BitmapDescriptor>{};
  final Map<Id, Image> cachedResult = <Id, Image>{};
  final Map<Id, UserIconProps> cachedProps = <Id, UserIconProps>{};
  final Map<Id, MarkerId> cachedMarkerIds = <Id, MarkerId>{};

  bool opacityLoaderPingPong = true;
  GoogleMapController? mapController;
  late final UserLastSeenImageNotifier userLastSeenImageNotifier =
      UserLastSeenImageNotifier(
    user: widget.user,
    size: UserIconSize.map,
    baseOpacity: 0.8,
  );
  late final UserLastSeenImageNotifier stalkerLastSeenImageNotifier =
      UserLastSeenImageNotifier(
    user: ActiveUser().value!,
    size: UserIconSize.map,
    baseOpacity: 0.95,
  );
  late final ValueNotifier<DateTime?> userLastSeenTextTickerNotifier =
      ValueNotifier(widget.user.lastLocationTimestamp);
  late final Ticker<String> userLastSeenTextTicker =
      Ticker(userLastSeenTextTickerNotifier, kTickerTextThresholds);
  final ValueNotifier<double> fabOpacity = ValueNotifier(1);
  bool hasCentered = false;
  Set<Marker> markers = {};
  bool hideMap = false;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    userLastSeenImageNotifier.addListener(_updateTarget);
    stalkerLastSeenImageNotifier.addListener(_updateStalker);
    liveUser.addListener(_updateTarget);
    ActiveUser().addListener(_updateStalker);
    _initMarkers();
  }

  void _monitorTarget() async {
    final db = await Db.db;
    liveUser.inCollection(db.users);
  }

  void _initMarkers() async {
    await _updateMarker(userLastSeenImageNotifier.value);
    await _updateMarker(stalkerLastSeenImageNotifier.value);
  }

  @override
  void dispose() {
    liveUser.dispose();
    stalkMachine.dispose();
    userLastSeenImageNotifier.dispose();
    userLastSeenTextTicker.dispose();
    stalkerLastSeenImageNotifier.dispose();
    ActiveUser().removeListener(_updateStalker);
    super.dispose();
  }

  Future<void> _updateMarker(UserIconProps props) async {
    if (!props.user.hasLocation) {
      return;
    }

    await _fetchIconForUser(props);
    setState(() {
      markers = {...markers, _markerFromUser(props.user)};
    });
  }

  Future<bool> _fetchIconForUser(UserIconProps props) async {
    final result = await UserIconProvider().fetch(props);
    if (cachedProps[props.user.id] == props &&
        cachedResult[props.user.id] == result &&
        cachedImages[props.user.id] != null) {
      return false;
    }
    cachedProps[props.user.id] = props;
    cachedResult[props.user.id] = result;

    final bitmapHelper = await BitmapHelper.fromProvider(result.image);
    final headed = bitmapHelper.buildHeaded();
    if (props.grayScale == 0) {
      cachedImages[props.user.id] = BitmapDescriptor.fromBytes(headed);
    } else {
      final image = img.decodeImage(headed);
      final grayScale = img.grayscale(image!, amount: props.grayScale);
      cachedImages[props.user.id] =
          BitmapDescriptor.fromBytes(img.encodePng(grayScale));
      // TODO cache image processing
    }
    return true;
  }

  void _updateTarget() {
    userLastSeenImageNotifier.event.value =
        liveUser.value?.lastLocationTimestamp;
    userLastSeenTextTickerNotifier.value =
        liveUser.value?.lastLocationTimestamp;
    _updateMarker(
      userLastSeenImageNotifier.value.copyWith(user: liveUser.value),
    );
  }

  void _updateStalker() {
    stalkerLastSeenImageNotifier.event.value =
        ActiveUser().value!.lastLocationTimestamp;
    _updateMarker(
      stalkerLastSeenImageNotifier.value.copyWith(user: ActiveUser().value),
    );
  }

  Marker _markerFromUser(User e) {
    return Marker(
      markerId: cachedMarkerIds[e.id] ??= MarkerId('${e.id}'),
      alpha: (e.id == ActiveUser().value?.id
                  ? stalkerLastSeenImageNotifier
                  : userLastSeenImageNotifier)
              .value
              .opacity *
          0.8,
      position: LatLng(
        e.lastLocationLatitude!,
        e.lastLocationLongitude!,
      ),
      anchor: const Offset(0.5, 0.5),
      icon: cachedImages[e.id]!,
      onTap: () => fabOpacity.value = 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        hideMap = true;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 200));
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AnimatedBuilder(
            animation: StalkMessageHub().getRecentMessagesNotifier(),
            builder: (_, __) => Row(
              children: [
                UserDistanceFromStalker(
                    user: widget.user, withAwaySuffix: true),
                LoadingText(
                  length: StalkMessageHub().getRecentMessagesNotifier().value,
                ),
              ],
            ),
          ),
        ),
        body: Platform.isIOS
            ? Container()
            : AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: hideMap ? 0 : 1,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                    _maybeCenter();
                    controller.setMapStyle(
                        Theme.of(context).brightness == Brightness.dark
                            ? kDarkMap
                            : kLightMap);
                  },
                  markers: markers,
                  zoomControlsEnabled: false,
                  onTap: (latLng) => fabOpacity.value = 1,
                  initialCameraPosition: CameraPosition(
                    target: _centerLatLng(),
                    zoom: 16,
                  ),
                ),
              ),
        floatingActionButton: ValueListenableBuilder<double>(
          valueListenable: fabOpacity,
          builder: (_, __, child) => AnimatedOpacity(
            opacity: fabOpacity.value,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInQuint,
            child: child,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      ...[ActiveUser().value!, widget.user]
                          .map(
                            (e) => IconButton(
                              onPressed: () async {
                                final db = await Db.db;
                                final user = await db.users.get(e.id);
                                mapController?.moveCamera(
                                    CameraUpdate.newLatLng(
                                        _latLngFromUser(user!)));
                              },
                              icon: SizedBox(
                                width: 30,
                                height: 30,
                                child: Theme(
                                  data: ThemeData(
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .apply(fontSizeFactor: 0.5),
                                  ),
                                  child: UserIconWidget(
                                    user: e,
                                    size: UserIconSize.small,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      UserTimeSinceLastLocation(
                        user: widget.user,
                        style: Theme.of(context).textTheme.labelSmall,
                        textScaleFactor: 1,
                      ),
                    ],
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
                      } else {
                        stalkMachine.toggleContinuousMode();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                                'assets/images/eye-left-fuzz-small.png'),
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
                        ValueListenableBuilder<bool>(
                          valueListenable: stalkMachine.isInContinuousMode,
                          builder: (_, value, child) => value
                              ? const Positioned(
                                  top: 1,
                                  child: Text('∞', textScaleFactor: 0.7),
                                )
                              : Wrap(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  LatLng _centerLatLng() {
    final users = [
      if (ActiveUser().value?.hasLocation ?? false) ActiveUser().value!,
      if (liveUser.value?.hasLocation ?? false) liveUser.value!,
    ];
    if (users.isEmpty) {
      return const LatLng(45.529203417794825, -122.69094861252296);
    }

    final latLng = users
        .map((e) => LatLng(e.lastLocationLatitude!, e.lastLocationLongitude!));
    return LatLng(
      latLng.map((e) => e.latitude).reduce((x, y) => x + y) / latLng.length,
      latLng.map((e) => e.longitude).reduce((x, y) => x + y) / latLng.length,
    );
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    var x0 = list.first.latitude;
    var x1 = list.first.latitude;
    var y0 = list.first.longitude;
    var y1 = list.first.longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  void _maybeCenter() async {
    if (hasCentered) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mapController != null && markers.length > 1 && !hasCentered) {
      hasCentered = true;
      mapController!.moveCamera(CameraUpdate.newLatLngBounds(
          boundsFromLatLngList(markers.map((e) => e.position).toList()), 100));
    }
  }
}

LatLng _latLngFromUser(User user) {
  return LatLng(
    user.lastLocationLatitude ?? 45.529203417794825,
    user.lastLocationLongitude ?? -122.69094861252296,
  );
}
