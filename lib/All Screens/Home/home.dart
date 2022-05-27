import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/Ride%20Start/rideStart.dart';
import 'package:ride_star/All%20Screens/map/map_services.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:ride_star/Provider/authenticationProvider.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Utils/custom_toast.dart';

import '../../Images/images.dart';
import '../../Provider/tripProvider.dart';
import '../ConstFile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool checkStatus = false;
  TripProvider driverTripProvider = TripProvider();
  final Set<Marker> _markers = {};
  late LatLng currentLaltg;
  final Set<Marker> markers = new Set();
  var driverCurrentLoaction;
  var diveraddress;
  var drivercurrentlat;
  var drivercurrentlong;

  var destinationLoaction;
  var destinationaddress;
  var destinationcurrentlat;
  var destinationcurrentlong;

  String tripfear = '';
  String prise = '';
  String diatance = '';
  String time = '';
  bool fear = false;

  GoogleMapController? myController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  Completer<GoogleMapController> _controller = Completer();
  double lat = 30.029585;
  double lng = 31.022356;
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  final LatLng destinationLatLng = LatLng(30.060567, 30.962413);

  // Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;

  bool mapDarkMode = true;

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    locatePosition();
    // driverTripProvider = Provider.of<TripProvider>(context, listen: false);
    // _loadMapStyles();
    super.initState();
  }

  locatePosition() async {
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
      currentLaltg = LatLng(position.latitude, position.longitude);
      // addmarkers(latLatPosition);
      CameraPosition cameraPosition =
          new CameraPosition(target: currentLaltg, zoom: 14);
      myController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      addmarkers(currentLaltg);
    }
  }

  Future<Set<Marker>> addmarkers(showLocation) async {
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('driver'),
          position: showLocation,
          infoWindow: InfoWindow(title: 'Driver'),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker));
    });
    return markers;
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
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(20.h),
            Container(
              height: 350.h,
              width: 343.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.black,
              ),
              child: GoogleMap(
                mapType: MapType.terrain,
                rotateGesturesEnabled: true,
                zoomGesturesEnabled: true,
                trafficEnabled: false,
                tiltGesturesEnabled: false,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: initialLatLng,
                  zoom: 14.47,
                ),
                onMapCreated: (GoogleMapController controller) {
                  myController = controller;
                  _controller.complete(controller);
                  // _setMapPins([LatLng(30.029585, 31.022356)]);
                  // _setMapStyle();
                  // _addPolyLines();
                },
              ),
            ),
            CustomWidget.heightSizedBoxWidget(21.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlacePicker(
                          apiKey: mapKey,
                          hintText: "Find a place ...",
                          searchingText: "Please wait ...",
                          selectText: "Select place",
                          outsideOfPickAreaText: "Place not in area",
                          initialPosition: currentLaltg,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            driverCurrentLoaction = result;
                            Navigator.of(context).pop();
                            setState(() {
                              print(driverCurrentLoaction.formattedAddress);
                              print(
                                  driverCurrentLoaction.geometry!.location.lat);
                              print(driverCurrentLoaction.geometry!.location.lng
                                  .toString());

                              diveraddress =
                                  driverCurrentLoaction.formattedAddress;

                              drivercurrentlat =
                                  driverCurrentLoaction.geometry!.location.lat;
                              drivercurrentlong = driverCurrentLoaction
                                  .geometry!.location.lng
                                  .toString();
                            });
                          })),
                );
              },
              child: diveraddress == null
                  ? CustomWidget.textWidgetWithBorder(
                      'Driver’s current loaction')
                  : CustomWidget.textWidgetWithBorder(
                      driverCurrentLoaction!.formattedAddress,
                    ),
            ),
            CustomWidget.heightSizedBoxWidget(21.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlacePicker(
                          apiKey: mapKey,
                          hintText: "Find a place ...",
                          searchingText: "Please wait ...",
                          selectText: "Select place",
                          outsideOfPickAreaText: "Place not in area",
                          initialPosition: currentLaltg,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            destinationLoaction = result;
                            Navigator.of(context).pop();
                            setState(() {
                              print(destinationLoaction.formattedAddress);
                              print(destinationLoaction.geometry!.location.lat);
                              print(destinationLoaction.geometry!.location.lng
                                  .toString());

                              destinationaddress =
                                  destinationLoaction.formattedAddress;

                              destinationcurrentlat =
                                  destinationLoaction.geometry!.location.lat;
                              destinationcurrentlong = destinationLoaction
                                  .geometry!.location.lng
                                  .toString();
                            });
                          })),
                );
              },
              child: destinationaddress == null
                  ? CustomWidget.textWidgetWithBorder('Destination')
                  : CustomWidget.textWidgetWithBorder(
                      destinationLoaction!.formattedAddress,
                    ),
            ),
            CustomWidget.heightSizedBoxWidget(21.h),
            fearWidgetContainer(),
            // checktextFormField('Fare', m1, true, 0xff606060, 12.sp,
            //     FontWeight.w400, 0xffAEAEB2),
            CustomWidget.heightSizedBoxWidget(41.h),
            // CustomWidget.customButtonWidget(
            //     context, '/enterMobileNumber', 'Next  ')
            InkWell(
              onTap: () {
                if (diveraddress == null) {
                  ToastUtils.showCustomToast(context,
                      'Driver’s current loaction is Missing', Colors.red);
                } else if (destinationaddress == null) {
                  ToastUtils.showCustomToast(
                      context, 'Destination loaction is Missing', Colors.red);
                } else {
                  AppRoutes.push(
                      context,
                      RideStart(
                          pickUpLat: drivercurrentlat,
                          pickUpLong: drivercurrentlong,
                          dropLat: destinationcurrentlat,
                          dropLong: destinationcurrentlong));
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
                        "Next",
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
          ],
        ),
      ),
    );
  }

  Widget textFormField(String hinttext, String prefixicon, bool keyBordType,
      hinttextcolor, hinttextsize, hinttextFontWeight, borderColor) {
    return Container(
      height: 56.h,
      width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(borderColor), width: 1),
      ),
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

  Widget checktextFormField(
      String hinttext,
      String prefixicon,
      bool keyBordType,
      hinttextcolor,
      hinttextsize,
      hinttextFontWeight,
      borderColor) {
    return Container(
      height: 56.h,
      width: 323.w,
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
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 10.w, left: 10),
              height: 36.h,
              width: 100.w,
              child: Center(
                  child: CustomWidget.textWidget('Check', 'Encode Sans', 12.sp,
                      FontWeight.w700, 0xff319C02)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xff319C02),
                    width: 1,
                  )),
            ),
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

  Widget fearWidgetContainer() {
    return Container(
        height: 56.h,
        width: 323.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xffAEAEB2),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(1.h),
        child: Row(
          children: [
            const Image(image: AssetImage(m1)),
            CustomWidget.widthSizedBoxWidget(6.w),
            Text(
              "Fare",
              style: TextStyle(
                color: const Color(0xff606060),
                fontSize: 12.sp,
                fontFamily: 'Encode Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                setState(() {
                  checkStatus = !checkStatus;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w, left: 10),
                height: 36.h,
                width: 100.w,
                child: Center(
                    child: CustomWidget.textWidget(
                        'Check',
                        'Encode Sans',
                        12.sp,
                        FontWeight.w700,
                        checkStatus == true ? 0xff319C02 : 0xff606060)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: checkStatus == true
                          ? Color(0xff319C02)
                          : Color(0xff606060),
                      width: 1,
                    )),
              ),
            ),
          ],
        ));
  }
}
