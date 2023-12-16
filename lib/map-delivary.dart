// import 'package:JAFFA/history-orders.dart';
// import 'package:floating_action_bubble/floating_action_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class MapDelivary extends StatefulWidget {
//   const MapDelivary({super.key});

//   @override
//   State<MapDelivary> createState() => _MapDelivaryState();
// }

// class _MapDelivaryState extends State<MapDelivary>
//     with SingleTickerProviderStateMixin {
//   String infoText = '';
//   Animation<double>? _animation;
//   AnimationController? _animationController;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 260),
//     );

//     final curvedAnimation =
//         CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
//     _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

//     super.initState();
//   }

//   late GoogleMapController mapController;
//   List<String> orderAddresses = [
//     "فلسطين, نابلس, زواتا, كازية الهدى",
//     "فلسطين, نابلس, جامعة النجاح",
//     "فلسطين, نابلس, المخفية,مديريةالصحة",
//     // Add more addresses as needed
//   ];

//   String originAddress =
//       "فلسطين, نابلس, شارع تل, صيدلية الضميدي"; // Add your origin address here
//   String originTitle = "مـــوقعــك"; // Custom title for the origin marker

//   Set<Marker> markers = Set<Marker>();
//   Set<Polyline> polylines = Set<Polyline>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           alignment: Alignment.topRight,
//           child: Text(
//             'خـــريــطــة الطـــلـبــات',
//             style: TextStyle(
//               fontFamily: "Lateef",
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: GoogleMap(
//                   onMapCreated: (controller) {
//                     mapController = controller;
//                     _addMarkers();
//                   },
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(0.0, 0.0),
//                     zoom: 3.0,
//                   ),
//                   markers: markers,
//                   polylines: polylines,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(left: 0.0, bottom: 100.0),
//         child: Container(
//           alignment: Alignment.bottomLeft,
//           child: FloatingActionBubble(
//             items: <Bubble>[
//               Bubble(
//                 title: "طلباتك",
//                 iconColor: Colors.white,
//                 bubbleColor: Colors.blue,
//                 icon: Icons
//                     .delivery_dining_outlined, // Use a built-in icon that resembles an image
//                 titleStyle: TextStyle(fontSize: 16, color: Colors.white),
//                 onPress: () {
//                   _animationController!.reverse();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const HistoryOrders(),
//                     ),
//                   );
//                 },
//               ),
//               Bubble(
//                 title: "تم التوصيل",
//                 iconColor: Colors.white,
//                 bubbleColor: Colors.blue,
//                 icon: Icons.history,
//                 titleStyle: TextStyle(fontSize: 16, color: Colors.white),
//                 onPress: () {
//                   _animationController!.reverse();
//                 },
//               ),
//               Bubble(
//                 title: "خروج",
//                 iconColor: Colors.white,
//                 bubbleColor: Colors.blue,
//                 icon: Icons.logout,
//                 titleStyle: TextStyle(fontSize: 16, color: Colors.white),
//                 onPress: () {
//                   _animationController!.reverse();
//                 },
//               ),
//             ],
//             animation: _animation!,
//             onPress: () => _animationController!.isCompleted
//                 ? _animationController!.reverse()
//                 : _animationController!.forward(),
//             backGroundColor: Colors.blue,
//             iconColor: Colors.white,
//             iconData: Icons.menu,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _addMarkers() async {
//     LatLng originLatLng =
//         await _addMarkerFromAddress(originAddress, originTitle, Colors.blue);

//     double minDistance = double.infinity;
//     LatLng nearestOrderLatLng = LatLng(0.0, 0.0);

//     for (String address in orderAddresses) {
//       LatLng destinationLatLng =
//           await _addMarkerFromAddress(address, 'Order Location', Colors.red);
//       _addPolyline(originLatLng, destinationLatLng);

//       // Calculate distance from origin to each order
//       double distance =
//           await _calculateDistance(originLatLng, destinationLatLng);

//       // Update the nearest order if a closer one is found
//       if (distance < minDistance) {
//         minDistance = distance;
//         nearestOrderLatLng = destinationLatLng;
//       }
//     }

//     // Add a special colored polyline for the nearest order
//     _addSpecialPolyline(originLatLng, nearestOrderLatLng);

//     setState(() {});
//   }

//   Future<LatLng> _addMarkerFromAddress(
//       String address, String title, Color color) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         LatLng latLng =
//             LatLng(locations.first.latitude!, locations.first.longitude!);

//         // Add a marker with additional information about destination and time
//         markers.add(
//           Marker(
//             markerId: MarkerId(address),
//             position: latLng,
//             infoWindow: InfoWindow(
//               title: title,
//               snippet: address,
//               onTap: () {},
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(color == Colors.blue
//                 ? BitmapDescriptor.hueBlue
//                 : BitmapDescriptor.hueRed),
//           ),
//         );
//         return latLng;
//       } else {
//         print("No locations found for the provided address: $address");
//         return LatLng(0.0, 0.0);
//       }
//     } catch (e) {
//       print("Error: $e");
//       return LatLng(0.0, 0.0);
//     }
//   }

//   Future<double> _calculateTime(LatLng origin, LatLng destination) async {
//     double distance = await _calculateDistance(origin, destination);

//     // Assuming average speed is 50 meters per minute
//     double averageSpeed = 50.0;

//     // Calculate time in minutes
//     double timeInMinutes = distance / averageSpeed;

//     return timeInMinutes;
//   }

//   void _addPolyline(LatLng origin, LatLng destination) {
//     Polyline polyline = Polyline(
//       polylineId: PolylineId('${origin.hashCode}-${destination.hashCode}'),
//       color: Colors.blue,
//       width: 5,
//       points: [origin, destination],
//     );

//     polylines.add(polyline);
//   }

//   void _addSpecialPolyline(LatLng origin, LatLng destination) {
//     Polyline polyline = Polyline(
//       polylineId: PolylineId('${origin.hashCode}-${destination.hashCode}'),
//       color: Colors.green, // You can customize the color for the nearest order
//       width: 5,
//       points: [origin, destination],
//     );

//     polylines.add(polyline);
//   }

//   Future<double> _calculateDistance(LatLng origin, LatLng destination) async {
//     // You can use a distance calculation library or the Haversine formula
//     // Here, we're using the Geodesic distance provided by the location package
//     double distance = await Geolocator.distanceBetween(
//       origin.latitude,
//       origin.longitude,
//       destination.latitude,
//       destination.longitude,
//     );

//     return distance;
//   }
// }

import 'dart:async';

import 'package:JAFFA/constants.dart';

import 'package:JAFFA/history-orders.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDelivery extends StatefulWidget {
  const MapDelivery({super.key});

  @override
  State<MapDelivery> createState() => _MapDeliveryState();
}

class _MapDeliveryState extends State<MapDelivery>
    with SingleTickerProviderStateMixin {
  String infoText = '';
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  LatLng? pickLocation;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.9522,
        35.2332), // Use the specific coordinates for the location in Palestine
    zoom: 7.0, // You can adjust the zoom level as needed
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> plineCoordinatedList = [];
  Set<Polyline> polylineSet = {};
  Set<Polygon> polygonSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  bool openNavigatorDrawer = false;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  locateUserPosition(GoogleMapController controller) async {
    Position position = await _determinePosition();
    userCurrentPosition = position;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 14)));

    setState(() {
      markerSet.clear();

      markerSet.add(Marker(
        markerId: MarkerId('currentLocation'),
        infoWindow: InfoWindow(title: "ORIGIN"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(position.latitude, position.longitude),
      ));

      // markerSet.add(Marker(
      //   markerId:
      //       MarkerId('destinationLocation'), // Unique MarkerId for destination
      //   infoWindow: InfoWindow(title: "DESTINATION"),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //   position: LatLng(32.2254, 35.2545),
      // ));

      polylineSet.clear();
      polylineSet.add(Polyline(
        polylineId: PolylineId('_kPolyline'),
        points: [
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude),
          LatLng(32.2254, 35.2545),
        ],
        width: 5,
      ));
      polygonSet.clear();
      polygonSet.add(
        Polygon(
          polygonId: PolygonId('Polygone'),
          points: [
            LatLng(
                userCurrentPosition!.latitude, userCurrentPosition!.longitude),
            LatLng(32.2254, 35.2545),
            LatLng(32.0, userCurrentPosition!.longitude),
            LatLng(
                userCurrentPosition!.latitude, userCurrentPosition!.longitude),
          ],
          strokeWidth: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              // polylines: polylineSet,
              // polygons: polygonSet,
              markers: markerSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});
                locateUserPosition(controller);
              },
              onCameraMove: (CameraPosition? position) {
                if (pickLocation != position!.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                //getAddressFromLatLng();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 35,
                ),
                child: Image.asset(
                  "assets/Backgrounds/logo.png",
                  height: 45,
                  width: 45,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 0.0, bottom: 100.0),
          child: Container(
            alignment: Alignment.bottomLeft,
            child: FloatingActionBubble(
              items: <Bubble>[
                Bubble(
                  title: "طلباتك",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons
                      .delivery_dining_outlined, // Use a built-in icon that resembles an image
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _animationController!.reverse();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryOrders(),
                      ),
                    );
                  },
                ),
                Bubble(
                  title: "تم التوصيل",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.history,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _animationController!.reverse();
                  },
                ),
                Bubble(
                  title: "خروج",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.logout,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _animationController!.reverse();
                  },
                ),
              ],
              animation: _animation!,
              onPress: () => _animationController!.isCompleted
                  ? _animationController!.reverse()
                  : _animationController!.forward(),
              backGroundColor: Colors.blue,
              iconColor: Colors.white,
              iconData: Icons.menu,
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}



// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CurrentLocationScreen extends StatefulWidget {
//   const CurrentLocationScreen({Key? key}) : super(key: key);

//   @override
//   _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
// }

// class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
//   late GoogleMapController googleMapController;

//   static const CameraPosition initialCameraPosition = CameraPosition(
//       target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

//   Set<Marker> markers = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User current location"),
//         centerTitle: true,
//       ),
//       body: GoogleMap(
//         initialCameraPosition: initialCameraPosition,
//         markers: markers,
//         zoomControlsEnabled: false,
//         mapType: MapType.normal,
//         onMapCreated: (GoogleMapController controller) {
//           googleMapController = controller;
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           Position position = await _determinePosition();

//           googleMapController.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                   target: LatLng(position.latitude, position.longitude),
//                   zoom: 14)));

//           markers.clear();

//           markers.add(Marker(
//               markerId: const MarkerId('currentLocation'),
//               position: LatLng(position.latitude, position.longitude)));

//           setState(() {});
//         },
//         label: const Text("Current Location"),
//         icon: const Icon(Icons.location_history),
//       ),
//     );
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled');
//     }

//     permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();

//       if (permission == LocationPermission.denied) {
//         return Future.error("Location permission denied");
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied');
//     }

//     Position position = await Geolocator.getCurrentPosition();

//     return position;
//   }
// }
