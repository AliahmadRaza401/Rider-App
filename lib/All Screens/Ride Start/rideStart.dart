import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_star/All%20Screens/ConstFile.dart';
import 'package:ride_star/All%20Screens/Payment%20Method/paymentMethod.dart';
import 'package:ride_star/All%20Screens/map/distace_calculate.dart';
import 'package:ride_star/All%20Screens/map/map_services.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Utils/custom_toast.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class RideStart extends StatefulWidget {
  double pickUpLat;
  double pickUpLong;
  double dropLat;
  double dropLong;
  String? destinationString;
  bool ischeck;

  RideStart({
    required this.pickUpLat,
    required this.pickUpLong,
    required this.dropLat,
    required this.dropLong,
    required this.destinationString,
    required this.ischeck
  });

  @override
  State<RideStart> createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? myController;
  final Set<Marker> _markers = {};
  late LatLng currentLaltg;
  final Set<Marker> markers = Set();
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;
  final Set<Circle> circle = Set<Circle>();
  var rideTime = 0.0;
  var ridedistance = 0.0;
  late LatLng distination;
  late LatLng pickupLatlng;
  late StreamSubscription geoLocatorListiner;
  bool isStart = false;
  @override
  void initState() {
    super.initState();
    // userProvider = Provider.of<UserProvider>(context, listen: false);
    _polylinePoints = PolylinePoints();
    setState(() {
      distination = LatLng(widget.dropLat, widget.dropLong);
      pickupLatlng = LatLng(widget.pickUpLat, widget.pickUpLong);
    });
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController _cntlr) {
    _mapController = _cntlr;
    log(widget.pickUpLat.toString());
    addDestinationMarkers(LatLng(widget.dropLat, widget.dropLong));
    addPickupMarkers(LatLng(widget.pickUpLat, widget.pickUpLong));
    setPolylineOnMap(
        widget.pickUpLat, widget.pickUpLong, widget.dropLat, widget.dropLong);
    ridedistance = calculateHarvesineDistanceInKM(pickupLatlng, distination);
    rideTime = calculateETAInMinutes(ridedistance, 30);
    CameraPosition cameraPosition =
        CameraPosition(target: pickupLatlng, zoom: 10);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
      body: SingleChildScrollView(
        child: Container(
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
              CustomWidget.heightSizedBoxWidget(40.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget.textWidget(
                  'Destination',
                  'Encode Sans',
                  22.sp,
                  FontWeight.w600,
                  0xff000000,
                ),
              ),
              CustomWidget.heightSizedBoxWidget(8.h),
              widget.destinationString!.isNotEmpty
                  ? Container(
                      // height: 56.h,
                      width: 343.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xff606060),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 5.h,
                        bottom: 5.h,
                        left: 4.w,
                        right: 4.w,
                      ),
                      child: Row(
                        children: [
                          const Image(image: AssetImage(location)),
                          CustomWidget.widthSizedBoxWidget(15.0),
                          Flexible(
                            child: Text(
                              widget.destinationString!,
                              style: TextStyle(
                                  fontFamily: 'Encode Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: const Color(
                                    0xff606060,
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomWidget.textWidget('Destination',
                          'Encode Sans', 18.sp, FontWeight.w600, 0xff000000),
                    ),
              CustomWidget.heightSizedBoxWidget(10.h),
              CustomWidget.heightSizedBoxWidget(40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  richTextWidget(location, 'Distance', ridedistance.toString()),
                  richTextWidget(m1, 'Fare', ridedistance.toString() * 20),
                  richTextWidget(history, 'Estimate time', rideTime.toString()),
                ],
              ),
              CustomWidget.heightSizedBoxWidget(20.h),
              InkWell(
                onTap: () {
                  setState(() {
                    isStart = !isStart;
                  });
                  if (!isStart) {
                    getLiveLocationUpdate();
                  }
                },
                child: Container(
                    height: 56.h,
                    width: 323.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      // color: const Color(0xffCE1A17),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0xffEAC4C7),
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.55),
                        ),
                      ],
                      color: const Color(0xffCE1A17),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isStart ? "Stop" : "Start",
                          style: TextStyle(
                              color: const Color(0xffFFFFFF),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Encode Sans'),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xffFFFFFF),
                        )
                      ],
                    )),
              ),
                CustomWidget.heightSizedBoxWidget(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormField(
    String hinttext,
    String prefixicon,
    bool keyBordType,
    hinttextcolor,
    hinttextsize,
    hinttextFontWeight,
    borderColor,
  ) {
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
          textInputAction: TextInputAction.next,
          keyboardType: keyBordType == true
              ? TextInputType.number
              : TextInputType.emailAddress,
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
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Image(
                  image: AssetImage(img),
                ),
              ),
              TextSpan(
                  // text: text2,
                  text:
                      text2.length > 10 ? text2.substring(0, 5) + '...' : text2,
                  style: TextStyle(
                    color: const Color(0xff2B2B2B),
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
    log('i am in the location function');
    // Permission for location from user

    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      log("Location is Off =======================>>");
    } else {
      log("Location is ON =======================>>");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // var currentPosition = position;
      LatLng latLatPosition = LatLng(position.latitude, position.longitude);
      // addmarkers(latLatPosition);
      CameraPosition cameraPosition =
          CameraPosition(target: latLatPosition, zoom: 20);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

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
    geoLocatorListiner =
        Geolocator.getPositionStream().listen((Position position) {
      print("listiner");
      LatLng liveLocation = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: liveLocation, zoom: 15);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      print("Camera animate Done");
      setState(() {
        markers.removeWhere((marker) => marker.markerId.value == 'driver');
        print("1________________________________");
        addmarkers(liveLocation);
        print("2______________________________ Done");
        ridedistance =
            calculateHarvesineDistanceInKM(pickupLatlng, distination);
        rideTime = calculateETAInMinutes(ridedistance, 30);
        log('ridedistance: $ridedistance');
        if (ridedistance == 0 || ridedistance <0.7633422577012097) {
          log('Distance Complete');
          ToastUtils.showCustomToast(context, "Reached", Colors.green);
          geoLocatorListiner.cancel();
          AppRoutes.push(
              context,
              PaymentMethod(
                // widget.pickUpLat, widget.pickUpLong
                pickUpLat: widget.pickUpLat,
                pickUpLong: widget.pickUpLong,
                dropLat: liveLocation.latitude,
                dropLong: liveLocation.longitude,
                ichecked: widget.ischeck,
              ));
        }
      });
    });
  }

  void setPolylineOnMap(
    double startLat,
    double startLong,
    double destiLat,
    double pickUpLong,
  ) async {
    log("String Polyline..............................");

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(startLat, startLong),
        PointLatLng(destiLat, pickUpLong));
    log(result.errorMessage.toString());
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polyline.add(Polyline(
            width: 4,
            polylineId: PolylineId('polyline'),
            color: Colors.red,
            points: _polylineCoordinates));
      });
    } else {
      log("Polyline Not Generated!!!!!!!!!!!!!!!!");
    }
  }

  Future<Set<Marker>> addmarkers(showLocation) async {
    // Uint8List imageData = await MapServices.getMarkerImage(context);
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(80);
    //markers to place on map
    setState(() {
      markers.add(Marker(
          markerId: const MarkerId('driver'),
          position: showLocation,
          infoWindow: const InfoWindow(title: 'Driver'),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));
    });
    return markers;
  }

  Future<Set<Marker>> addDestinationMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize2(80);
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: showLocation,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    });
    return markers;
  }

  Future<Set<Marker>> addPickupMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize1(80);
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: showLocation,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
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
