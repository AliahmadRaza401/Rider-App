import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/Earning/earning.dart';
import 'package:ride_star/All%20Screens/Login%20Folder/logIn.dart';
import 'package:ride_star/All%20Screens/Ride%20Start/rideStart.dart';
import 'package:ride_star/All%20Screens/map/map_services.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:ride_star/Provider/authenticationProvider.dart';
import 'package:ride_star/Provider/userProvider.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Utils/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Images/images.dart';
import '../../Provider/tripProvider.dart';
import '../ConstFile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Uri url1 = Uri.parse('https://www.facebook.com/');
  final Uri url2 = Uri.parse('https://www.instagram.com/accounts/login/');
  String userImage = '';
  String userName = '';
  String userNumber = '';

  bool checkStatus = false;
  TripProvider driverTripProvider = TripProvider();
  final Set<Marker> _markers = {};
  late LatLng currentLaltg;
  final Set<Marker> markers = new Set();
  var driverCurrentLoaction;
  var diveraddress;
  double? drivercurrentlat;
  double? drivercurrentlong;

  var destinationLoaction;
  var destinationaddress;
  double? destinationcurrentlat;
  double? destinationcurrentlong;

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
    checkUserExist();
    locatePosition();
    // driverTripProvider = Provider.of<TripProvider>(context, listen: false);
    // _loadMapStyles();
    super.initState();
  }

  void _launchUrl(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  checkUserExist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('uid');
    print('id: $id');
    print('checkUser________________________________________!');
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['uid'].toString() == id.toString()) {
          print('doc Id : ${doc['uid']}');
          print('yes');
          setState(() {
            userImage = doc['userPic'].toString();
            print('userImage: $userImage');

            userName = doc['userName'].toString();
            print('userName: $userName');
            userNumber = doc['userMobile'].toString();
            print('userNumber: $userNumber');
          });
        }
      });
    });
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
      // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      print('position: $position');
      var currentPosition = position;
      currentLaltg = LatLng(position.latitude, position.longitude);
      print('currentLaltg: $currentLaltg');
      CameraPosition cameraPosition =
          CameraPosition(target: currentLaltg, zoom: 14);
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
      backgroundColor: Colors.white,
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
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              // height: 200,
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                // decoration: BoxDecoration(color: Colors.blue),
                child: ListTile(
                  title: userName.isEmpty
                      ? CustomWidget.textWidget(
                          'User Name',
                          'Encode Sans',
                          16.sp,
                          FontWeight.w600,
                          0xff2B2B2B,
                        )
                      : CustomWidget.textWidget(
                          userName,
                          'Encode Sans',
                          16.sp,
                          FontWeight.w600,
                          0xff2B2B2B,
                        ),
                  subtitle: userNumber.isEmpty
                      ? CustomWidget.textWidget(
                          'XXX-XXX-XXXX',
                          'Encode Sans',
                          16.sp,
                          FontWeight.w600,
                          0xff2B2B2B,
                        )
                      : CustomWidget.textWidget(
                          userNumber,
                          'Encode Sans',
                          16.sp,
                          FontWeight.w600,
                          0xff2B2B2B,
                        ),
                  leading: FadeInImage.assetNetwork(
                    placeholder: userprofile,
                    image: userImage,
                  ),
                ),

                // child: Text(
                //   'Right Drawer Header',
                //   style: TextStyle(color: Colors.white, fontSize: 24),
                // ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    onTap: () {
                      // AppRoutes.push(context, const Earning());
                    },
                    leading: const Image(
                      image: AssetImage(historyicon),
                    ),
                    title: CustomWidget.textWidget(
                      'Ride History',
                      'Encode Sans',
                      16.sp,
                      FontWeight.w600,
                      0xff2B2B2B,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffCE1A17),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      AppRoutes.push(context, const Earning());
                    },
                    leading: const Image(
                      image: AssetImage(earningsmall),
                    ),
                    title: CustomWidget.textWidget(
                      'Earnings',
                      'Encode Sans',
                      16.sp,
                      FontWeight.w600,
                      0xff2B2B2B,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffCE1A17),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      // AppRoutes.push(context, const Earning());
                    },
                    leading: const Image(
                      image: AssetImage(earningsmall),
                    ),
                    title: CustomWidget.textWidget(
                      'How To Use',
                      'Encode Sans',
                      16.sp,
                      FontWeight.w600,
                      0xff2B2B2B,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffCE1A17),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Image(
                      image: AssetImage(earningsmall),
                    ),
                    title: CustomWidget.textWidget(
                      'Privacy Policy',
                      'Encode Sans',
                      16.sp,
                      FontWeight.w600,
                      0xff2B2B2B,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffCE1A17),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      print('a');
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      setState(() {
                        print('b');
                        preferences.remove('uid');
                        print('c');
                        AppRoutes.replace(context, const LogInScreen());
                      });
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xffCE1A17),
                    ),
                    title: CustomWidget.textWidget(
                      'Logot',
                      'Encode Sans',
                      16.sp,
                      FontWeight.w600,
                      0xff2B2B2B,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffCE1A17),
                    ),
                  ),
                  // Expanded(
                  //   child: 
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 25.h),
                    child: Row(
                      children: [
                        const Image(image: AssetImage(shearwithyourFriends)),
                        SizedBox(
                          width: 20.w,
                        ),
                        CustomWidget.textWidget(
                          'Share with your friends',
                          'Encode Sans',
                          16.sp,
                          FontWeight.w600,
                          0xff2B2B2B,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            _launchUrl(url1);
                          },
                          child: const Image(image: AssetImage(fbook))),
                      SizedBox(
                        width: 20.w,
                      ),
                      InkWell(
                          onTap: () {
                            _launchUrl(url2);
                          },
                          child: const Image(image: AssetImage(insta))),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                            initialPosition:
                                currentLaltg == null ? _center : currentLaltg,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            onPlacePicked: (result) {
                              driverCurrentLoaction = result;
                              Navigator.of(context).pop();
                              setState(() {
                                print(driverCurrentLoaction.formattedAddress);
                                print(driverCurrentLoaction
                                    .geometry!.location.lat);
                                print(driverCurrentLoaction
                                    .geometry!.location.lng
                                    .toString());

                                diveraddress =
                                    driverCurrentLoaction.formattedAddress;

                                drivercurrentlat = driverCurrentLoaction
                                    .geometry!.location.lat;
                                drivercurrentlong = driverCurrentLoaction
                                    .geometry!.location.lng;
                              });
                            })),
                  );
                },
                child: diveraddress == null
                    ? CustomWidget.textWidgetWithBorder(
                        'Customer current loaction',
                      )
                    : Container(
                        width: 323.w,
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
                                driverCurrentLoaction!.formattedAddress,
                                style: const TextStyle(
                                    fontFamily: 'Encode Sans',
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                      0xff606060,
                                    )),
                              ),
                            )
                          ],
                        ),
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
                              initialPosition:
                                  currentLaltg == null ? _center : currentLaltg,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              usePinPointingSearch: true,
                              usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                destinationLoaction = result;
                                Navigator.of(context).pop();
                                setState(() {
                                  // print(destinationLoaction.formattedAddress);
                                  // print(destinationLoaction.geometry!.location.lat);
                                  // print(destinationLoaction.geometry!.location.lng
                                  //     .toString());

                                  destinationaddress =
                                      destinationLoaction.formattedAddress;

                                  destinationcurrentlat = destinationLoaction
                                      .geometry!.location.lat;
                                  destinationcurrentlong = destinationLoaction
                                      .geometry!.location.lng;
                                });
                              })),
                    );
                  },
                  child: destinationaddress == null
                      ? CustomWidget.textWidgetWithBorder('Destination')
                      : Container(
                          width: 323.w,
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
                                  destinationLoaction!.formattedAddress,
                                  style: const TextStyle(
                                      fontFamily: 'Encode Sans',
                                      fontWeight: FontWeight.w600,
                                      color: Color(
                                        0xff606060,
                                      )),
                                ),
                              )
                            ],
                          ),
                        )),
              CustomWidget.heightSizedBoxWidget(21.h),
              fearWidgetContainer(),
              CustomWidget.heightSizedBoxWidget(41.h),
              InkWell(
                onTap: () {
                  print("0");
                  if (diveraddress == null) {
                    print("1");
                    ToastUtils.showCustomToast(context,
                        'Customer  Loaction is Missing', Colors.red);
                  } else if (destinationaddress == null) {
                    print("2");
                    ToastUtils.showCustomToast(
                        context, 'Destination loaction is Missing', Colors.red);
                  } else {
                    print("sdfg");
                    AppRoutes.push(
                        context,
                        RideStart(
                          pickUpLat: drivercurrentlat!,
                          pickUpLong: drivercurrentlong!,
                          dropLat: destinationcurrentlat!,
                          dropLong: destinationcurrentlong!,
                          destinationString:
                              destinationLoaction!.formattedAddress,
                          ischeck: checkStatus,
                        ));
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
              CustomWidget.heightSizedBoxWidget(20.h),
            ],
          ),
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
                // CameraPosition cameraPosition = CameraPosition(
                //     target: LatLng(31.520370, 74.358749), zoom: 14);
                // myController!.animateCamera(
                //     CameraUpdate.newCameraPosition(cameraPosition));
                // addmarkers(LatLng(31.520370, 74.358749));
                locatePosition();
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

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await myController!;
    controller.dispose();
    super.dispose();
  }
}
