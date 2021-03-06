// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison, unnecessary_new, must_be_immutable, use_key_in_widget_constructors, prefer_collection_literals, unused_field

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/map/distace_calculate.dart';
import 'package:ride_star/All%20Screens/map/map_services.dart';

class GoMap extends StatefulWidget {
  double pickUpLat;
  double pickUpLong;
  double dropLat;
  double dropLong;
  String driverID;
  bool isPickup;
  dynamic data;

  GoMap(
      {required this.pickUpLat,
      required this.pickUpLong,
      required this.dropLat,
      required this.dropLong,
      required this.driverID,
      required this.data,
      required this.isPickup});

  @override
  _GoMapState createState() => _GoMapState();
}

class _GoMapState extends State<GoMap> {
  final Set<Marker> _markers = {};
  late LatLng currentLaltg;
  final Set<Marker> markers = new Set();
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;
  final Set<Circle> circle = Set<Circle>();
  var rideTime = 0.0;
  var ridedistance = 0.0;
  late LatLng distination;
  late StreamSubscription geoLocatorListiner;

  @override
  void initState() {
    super.initState();
    // userProvider = Provider.of<UserProvider>(context, listen: false);
    _polylinePoints = PolylinePoints();
    if (widget.isPickup == false) {
      setState(() {
        distination = LatLng(widget.pickUpLat, widget.pickUpLong);
      });
    } else {
      setState(() {
        distination = LatLng(widget.dropLat, widget.dropLong);
      });
    }
    // FCMServices.sendFCM(
    //   'user',
    //   widget.userID,
    //   "Start Moving",
    //   "Barbar Now Start Moving",
    // );
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController _cntlr) {
    _mapController = _cntlr;
    log(widget.pickUpLat.toString());
    addDestinationMarkers(LatLng(widget.dropLat, widget.dropLong));
    addPickupMarkers(LatLng(widget.pickUpLat, widget.pickUpLong));
    getDriverData();
    locatePosition(context);
  }

  dynamic data;
  var trackStatus = '';

  Future<dynamic> getDriverData() async {
    FirebaseFirestore.instance
        .collection("drivers")
        .doc(widget.driverID)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          trackStatus = value['trackStatus'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customAppBar(context, "Tracking"),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              markers: markers,
              polylines: _polyline,
            ),
            // bottomDistanceCancelBtn(context, rideTime, ridedistance),
          ],
        ),
      ),
    );
  }

  locatePosition(BuildContext context) async {
    print('i am in the location function');
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      print("Location is Off =======================>>");
    } else {
      print("Location is ON =======================>>");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var currentPosition = position;
      LatLng latLatPosition = LatLng(position.latitude, position.longitude);
      // addmarkers(latLatPosition);
      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 14);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      await getLiveLocationUpdate();
      // Create Polylines
      if (_polylineCoordinates == null || _polylineCoordinates.isEmpty) {
        setPolylineOnMap(
          position.latitude,
          position.longitude,
          distination.latitude,
          distination.longitude,
        );
      }
    }
  }

  getLiveLocationUpdate() {
    LatLng oldPos = LatLng(0, 0);

    geoLocatorListiner =
        Geolocator.getPositionStream().listen((Position position) {
      LatLng liveLocation = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          new CameraPosition(target: liveLocation, zoom: 17);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      // Update data in DB
      MapServices.updateLocationInDB(
        widget.driverID,
        position.latitude,
        position.longitude,
      );

      setState(() async {
        markers.removeWhere((marker) => marker.markerId.value == 'driver');

        // _polyline.removeWhere((poline) => poline.polylineId.value == 'polyline');

        addmarkers(liveLocation);
        ridedistance =
            calculateHarvesineDistanceInKM(liveLocation, distination);
        rideTime = calculateETAInMinutes(ridedistance, 30);

        if (ridedistance == 0 || ridedistance < 0.10) {}
      });
    });
  }

  void setPolylineOnMap(double startLat, double startLong, double destiLat,
      double pickUpLong) async {
    print("String Polyline..............................");

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        "map key",
        PointLatLng(startLat, startLong),
        PointLatLng(destiLat, pickUpLong));
    log(result.errorMessage.toString());
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      // addDestinationMarkers(LatLng(destiLat, pickUpLong));
      setState(() {
        _polyline.add(Polyline(
            width: 4,
            polylineId: PolylineId('polyline'),
            color: Colors.orange,
            points: _polylineCoordinates));
      });
    } else {
      print("Polyline Not Generated!!!!!!!!!!!!!!!!");
    }
  }

  Future<Set<Marker>> addmarkers(showLocation) async {
    Uint8List imageData = await MapServices.getMarkerImage(context);
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(80);
    //markers to place on map
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('driver'),
          position: showLocation,
          infoWindow: InfoWindow(title: 'Driver'),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));
      //add more markers here
      // circle.add(Circle(
      //     circleId: CircleId("barbar"),
      //     // radius: showLocation.accuracy,
      //     radius: 30,
      //     zIndex: 1,
      //     strokeColor: themeColor,
      //     strokeWidth: 2,
      //     center: showLocation,
      //     fillColor: themeColor.withAlpha(70))
      // );
    });
    return markers;
  }

  Future<Set<Marker>> addDestinationMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize2(80);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("destination"),
          position: showLocation,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));
    });
    return markers;
  }

  Future<Set<Marker>> addPickupMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize1(80);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("pickup"),
          position: showLocation,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));
    });
    return markers;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _mapController;
    controller.dispose();
    geoLocatorListiner.cancel();
    super.dispose();
  }
}
