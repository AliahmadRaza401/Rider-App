

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/splashScreen/splashScreen.dart';

import 'All Screens/Home/home.dart';
<<<<<<< HEAD
import 'All Screens/Login Folder/logIn.dart';
import 'All Screens/splashScreen/splashScreen.dart';
=======
import 'All Screens/signUp/personal_Information.dart';
>>>>>>> c95e2366ef439db4caeb6cd82ef3c916f6b36290
import 'Provider/allProvider.dart';
import 'Provider/authenticationProvider.dart';
import 'Routes/routes.dart';

<<<<<<< HEAD
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const HomePage(),
=======
Future<void>  main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers:allProvider,
      child: const HomePage(),
    ),
>>>>>>> c95e2366ef439db4caeb6cd82ef3c916f6b36290
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, _) {
        return MultiProvider(
          providers: allProvider,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '',
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: (context, widget) {
              // ScreenUtil.setContext(context);

<<<<<<< HEAD
              return MediaQuery(
                //Setting font does not change with system font size
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            // home: const Home(),
            home: const LogInScreen(),
            // home: const PersonalInformation(),
            // home: const SplashScreen(),
          ),
=======
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
>>>>>>> c95e2366ef439db4caeb6cd82ef3c916f6b36290
        );
      },
    );
  }
}