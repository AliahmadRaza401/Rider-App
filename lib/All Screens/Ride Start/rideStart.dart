import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class RideStart extends StatefulWidget {
  const RideStart({Key? key}) : super(key: key);

  @override
  State<RideStart> createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
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
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50, 50)),
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
}
