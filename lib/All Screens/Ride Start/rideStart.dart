import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_star/All%20Screens/ConstFile.dart';
import 'package:ride_star/All%20Screens/map/distace_calculate.dart';
import 'package:ride_star/All%20Screens/map/map_services.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class RideStart extends StatefulWidget {
  double pickUpLat;
  double pickUpLong;
  double dropLat;
  double dropLong;

  RideStart({
    required this.pickUpLat,
    required this.pickUpLong,
    required this.dropLat,
    required this.dropLong,
  });

  @override
  State<RideStart> createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? myController;
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
    setState(() {
      distination = LatLng(widget.dropLat, widget.dropLong);
    });
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController _cntlr) {
    _mapController = _cntlr;
    log(widget.pickUpLat.toString());
    addDestinationMarkers(LatLng(widget.dropLat, widget.dropLong));
    addPickupMarkers(LatLng(widget.pickUpLat, widget.pickUpLong));
    locatePosition(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xffCE1A17)),
        backgroundColor: const Color(0xffE5E5E5),
        elevation: 0.0,
        actions: [
          const Icon(
            Icons.notifications,
            // color: Color(0xffCE1A17),
          ),
          CustomWidget.widthSizedBoxWidget(10.w),
        ],
      ),
      drawer: Drawer(),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(20.h),
            Container(
              height: 374.h,
              width: 343.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.black,
              ),
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: false,
                markers: markers,
                polylines: _polyline,
              ),
            ),
            CustomWidget.heightSizedBoxWidget(20.h),
            Align(
              alignment: Alignment.bottomLeft,
              child: CustomWidget.textWidget('Destination', 'Encode Sans',
                  18.sp, FontWeight.w600, 0xff000000),
            ),
            CustomWidget.heightSizedBoxWidget(10.h),
            textFormField('Driver’s current loaction', location, true,
                0xff606060, 12.sp, FontWeight.w400, 0xffAEAEB2),
            CustomWidget.heightSizedBoxWidget(40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                richTextWidget(location, 'Distance', '11 km'),
                richTextWidget(m1, 'Fare', '30'),
                richTextWidget(history, 'Estimate time', '20 min'),
              ],
            ),
            CustomWidget.heightSizedBoxWidget(20.h),
            CustomWidget.customButtonWithoutArrowWidget(
                context, '/paymentMethod', 'Start'),
          ],
        ),
      ),
    );
  }

  Widget textFormField(String hinttext, String prefixicon, bool keyBordType,
      hinttextcolor, hinttextsize, hinttextFontWeight, borderColor) {
    return Container(
      height: 56.h,
      // width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(borderColor), width: 1),
      ),
      padding: EdgeInsets.all(1.h),
      child: Center(
        child: TextFormField(
          // controller: myController,
          textInputAction: TextInputAction.next,
          keyboardType: keyBordType == true
              ? TextInputType.number
              : TextInputType.emailAddress,
          // // obscureText: password == true ? obscureText : false,
          // cursorColor:
          //     white == true ? AppColors.customWhite : AppColors.customBlack,
          // cursorWidth: 2.0,
          // cursorHeight: AppSizes.dynamicHeight(context, .03),
          style: TextStyle(
            color: const Color(0xff606060),
            fontSize: 12.sp,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hinttext,
            prefixIcon: Image(image: AssetImage(prefixicon)),
            hintStyle: TextStyle(
              color: Color(hinttextcolor),
              fontSize: hinttextsize,
              fontFamily: 'Encode Sans',
              fontWeight: hinttextFontWeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget richTextWidget(
    String img,
    String text1,
    String text2,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.textWidget(
            text1, 'Encode Sans', 14.sp, FontWeight.w600, 0xff2B2B2B),
        CustomWidget.heightSizedBoxWidget(8.h),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Image(
                  image: AssetImage(img),
                ),
              ),
              TextSpan(
                  text: text2,
                  style: TextStyle(
                    color: Color(0xff2B2B2B),
                    fontFamily: 'Encode Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ))
            ],
          ),
        ),
      ],
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
        mapKey,
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
            color: Colors.red,
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
