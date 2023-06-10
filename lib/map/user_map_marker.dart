// import 'dart:ui';
//
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:stalker/domain/user.dart';
// import 'package:stalker/ticker/ticker.dart';
//
// class UserMapMarkerProvider {
//   Marker provide(User e, Ticker<String> ticker) {
//     return Marker(
//       markerId: MarkerId('${e.id}'),
//       position: LatLng(
//         e.lastLocationLatitude!,
//         e.lastLocationLongitude!,
//       ),
//       anchor: const Offset(0.5, 0.5),
//       icon: BitmapDescriptor.fromBytes(cachedImages[e.id]!),
//       onTap: () => fabOpacity.value = 0,
//       infoWindow: InfoWindow(
//         title: '${userLastSeenTextTicker.value}',
//       ),
//     );
//   }
// }
