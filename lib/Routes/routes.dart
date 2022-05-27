import 'package:flutter/material.dart';
import 'package:ride_star/All%20Screens/Home/home.dart';
import 'package:ride_star/All%20Screens/enterMobileNumber/enterMobileNumber.dart';
import '../All Screens/ConformOTP/conformOTP.dart';
import '../All Screens/Earning/earning.dart';
import '../All Screens/EnterMobileNumber2.dart/enterMobileNumber2.dart';
import '../All Screens/Payment Method/paymentMethod.dart';
import '../All Screens/Ride Start/rideStart.dart';
import '../All Screens/signUp/drivingLicance.dart';
import '../All Screens/signUp/enlistmentCertificate.dart';
import '../All Screens/signUp/nationaIDCard.dart';
import '../All Screens/signUp/personal_Information.dart';
import '../All Screens/splashScreen/splashScreen.dart';

class Routes {
  static const String splashScreen = '/splashScreen';
  static const String personalInformation = '/personalInformation';
  static const String nationaIDCardScreen = '/nationaIDCardScreen';
  static const String drivingLicence = '/drivingLicence';
  static const String enlistmentCertificate = '/enlistmentCertificate';
  static const String home = '/home';
  static const String enterMobileNumber = '/enterMobileNumber';
  static const String conformOTP = '/conformOTP';
  static const String rideStart = '/rideStart';
  static const String paymentMethod = '/paymentMethod';
  static const String enterMobileNumber2 = '/enterMobileNumber2';
  static const String earning = '/earning';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case personalInformation:
        return MaterialPageRoute(
          builder: (context) => const PersonalInformation(),
        );
      case nationaIDCardScreen:
        return MaterialPageRoute(
          builder: (context) => const NationaIDCardScreen(),
        );
      case drivingLicence:
        return MaterialPageRoute(
          builder: (context) => const DrivingLicance(),
        );
      case enlistmentCertificate:
        return MaterialPageRoute(
          builder: (context) => const EnlistmentCertificate(),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      case enterMobileNumber:
        return MaterialPageRoute(
          builder: (context) => const EnterMobileNumber(),
        );
      // case conformOTP:
      //   return MaterialPageRoute(
      //     builder: (context) => const ConformOTP(),
      //   );
      // case rideStart:
      //   return MaterialPageRoute(
      //     builder: (context) => RideStart(),
      //   );
      case paymentMethod:
        return MaterialPageRoute(
          builder: (context) => const PaymentMethod(),
        );
      case enterMobileNumber2:
        return MaterialPageRoute(
          builder: (context) => const EnterMobileNumber2(),
        );
      case earning:
        return MaterialPageRoute(
          builder: (context) => const Earning(),
        );
      default:
        throw const FormatException('Route not found');
    }
  }
}
