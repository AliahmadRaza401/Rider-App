import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';

import '../../Images/images.dart';
import '../ConstFile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var driverCurrentLoaction;
  GoogleMapController? myController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  Completer<GoogleMapController> _controller = Completer();
  double lat = 30.029585;
  double lng = 31.022356;
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  final LatLng destinationLatLng = LatLng(30.060567, 30.962413);

  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;

  bool mapDarkMode = true;

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    // _loadMapStyles();
    super.initState();
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
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: initialLatLng,
                  zoom: 14.47,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // _setMapPins([LatLng(30.029585, 31.022356)]);
                  // _setMapStyle();
                  // _addPolyLines();
                },
              ),

              // child: GoogleMap(
              //   onMapCreated: _onMapCreated,
              //   initialCameraPosition: CameraPosition(
              //     target: _center,
              //     zoom: 11.0,
              //   ),
              // ),
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
                          initialPosition: initialLatLng,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            driverCurrentLoaction = result;
                            Navigator.of(context).pop();
                            setState(() {
                              print(driverCurrentLoaction);
                            });
                            // setState(() {
                            //   deliveryProvider.pickAddress.text =
                            //       selectedPlace2!.formattedAddress
                            //           .toString();
                            //   deliveryProvider.pickupLat =
                            //       selectedPlace2!
                            //           .geometry!.location.lat
                            //           .toString();
                            //   deliveryProvider.pickupLong =
                            //       selectedPlace2!
                            //           .geometry!.location.lng
                            //           .toString();
                            // });
                          })),
                );
              },
              child: Text('Driver’s current loaction')
              // textFormField('Driver’s current loaction', location, true,
              //     0xff606060, 12.sp, FontWeight.w400, 0xffAEAEB2),
            ),
            CustomWidget.heightSizedBoxWidget(21.h),
            textFormField('Destination', location, true, 0xff606060, 12.sp,
                FontWeight.w400, 0xffAEAEB2),
            CustomWidget.heightSizedBoxWidget(21.h),
            checktextFormField('Fare', m1, true, 0xff606060, 12.sp,
                FontWeight.w400, 0xffAEAEB2),
            CustomWidget.heightSizedBoxWidget(41.h),
            CustomWidget.customButtonWidget(
                context, '/enterMobileNumber', 'Next  ')
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
}
