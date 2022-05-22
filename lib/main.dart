import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/splashScreen/splashScreen.dart';

import 'All Screens/Home/home.dart';
import 'All Screens/signUp/personal_Information.dart';
import 'Provider/allProvider.dart';
import 'Provider/authenticationProvider.dart';
import 'Routes/routes.dart';

Future<void>  main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers:allProvider,
      child: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          onGenerateRoute: Routes.generateRoute,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(button: TextStyle(fontSize: 45.sp)),
          ),
          builder: (context, widget) {
            // ScreenUtil.setContext(context);

            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: const PersonalInformation(),
          // home: const AdminSideMenu(),
          // home: const Home(),

          // home: const SplashScreen(),
        );
      },
    );
  }
}
