import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/stalk/stalk_machine.dart';
import 'package:stalker/stalk/stalk_message_hub.dart';
import 'package:stalker/theme/loading_text.dart';
import 'package:stalker/ticker/ticker.dart';
import 'package:stalker/ticker/ticker_text.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_distance_from_stalker.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_icon_widget.dart';
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

  bool opacityLoaderPingPong = true;

  late final ValueNotifier<DateTime?> userLastSeenTextTickerNotifier =
      ValueNotifier(widget.user.lastLocationTimestamp);
  late final Ticker<String> userLastSeenTextTicker =
      Ticker(userLastSeenTextTickerNotifier, kTickerTextThresholds);
  final ValueNotifier<double> fabOpacity = ValueNotifier(1);

  final MapController mapController = MapController();
  Map<int, Marker> markers = {};
  bool hideMap = false;

  @override
  void initState() {
    super.initState();
    _monitorTarget();
    liveUser.addListener(_updateTarget);
    ActiveUser().addListener(_updateStalker);
    _updateMarker(ActiveUser().value);
    _updateMarker(liveUser.value);
  }

  void _monitorTarget() async {
    final db = await Db.db;
    liveUser.inCollection(db.users);
  }

  @override
  void dispose() {
    liveUser.dispose();
    stalkMachine.dispose();
    userLastSeenTextTicker.dispose();
    ActiveUser().removeListener(_updateStalker);
    super.dispose();
  }

  void _updateMarker(User? user) {
    if (user == null) {
      return;
    }

    if (!user.hasLocation) {
      setState(() {
        markers.remove([user.id]);
      });
      return;
    }

    markers[user.id] = _markerFromUser(user);
  }

  void _updateTarget() {
    userLastSeenTextTickerNotifier.value =
        liveUser.value?.lastLocationTimestamp;
    _updateMarker(liveUser.value);
    setState(() {});
  }

  void _updateStalker() {
    _updateMarker(ActiveUser().value);
    setState(() {});
  }

  Marker _markerFromUser(User e) {
    return Marker(
      point: LatLng(
        e.lastLocationLatitude!,
        e.lastLocationLongitude!,
      ),
      width: 50,
      height: 50,
      builder: (context) => Opacity(
        opacity: 0.9,
        child: UserIconWidget(
          user: e,
          withActivity: false,
        ),
      ),
      // onTap: () => fabOpacity.value = 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: AnimatedBuilder(
          animation: StalkMessageHub().getRecentMessagesNotifier(),
          builder: (_, __) => Row(
            children: [
              UserDistanceFromStalker(user: widget.user, withAwaySuffix: true),
              LoadingText(
                length: StalkMessageHub().getRecentMessagesNotifier().value,
              ),
            ],
          ),
        ),
      ),
      body: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: hideMap ? 0 : 1,
        child: markers.isEmpty
            ? Container()
            : FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  bounds: boundsFromLatLngList(markers.values
                      .map<LatLng>((value) => value.point)
                      .toList()),
                  boundsOptions:
                      const FitBoundsOptions(padding: EdgeInsets.all(40.0)),
                  interactiveFlags:
                      InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'gartz.stalker',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: markers.values.toList(),
                  )
                ],
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
                              mapController.move(
                                _latLngFromUser(user!),
                                mapController.zoom,
                              );
                              final marker = markers[user.id];
                              markers.remove(user.id);
                              markers = {
                                ...markers,
                                if (marker != null) user.id: marker,
                              };
                              setState(() {});
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

  static LatLngBounds? boundsFromLatLngList(List<LatLng> list) {
    if (list.isEmpty) {
      return null;
    } else if (list.length == 1) {
      const x = 0.01;
      return LatLngBounds(
        LatLng(list.first.latitude - x, list.first.longitude - x),
        LatLng(list.first.latitude + x, list.first.longitude + x),
      );
    }
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
    return LatLngBounds(LatLng(x1, y1), LatLng(x0, y0));
  }
}

LatLng _latLngFromUser(User user) {
  return LatLng(
    user.lastLocationLatitude ?? 45.529203417794825,
    user.lastLocationLongitude ?? -122.69094861252296,
  );
}
