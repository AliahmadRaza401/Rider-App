import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/Home/home.dart';
import 'package:ride_star/All%20Screens/Login%20Folder/logIn.dart';
import 'package:ride_star/Provider/userProvider.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Images/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('uid');
    print('id: $id');
    
    if (id != null) {
      userProvider.getUserById(id);
      AppRoutes.replace(context, const Home());
    } else {
      AppRoutes.push(context, const LogInScreen());
      // Navigator.pushNamed(context, '/personalInformation');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(geofence, )
      ),
    );
  }
}
