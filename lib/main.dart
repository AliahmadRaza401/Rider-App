import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'All Screens/Home/home.dart';
import 'All Screens/Login Folder/logIn.dart';
import 'All Screens/splashScreen/splashScreen.dart';
import 'Provider/allProvider.dart';
import 'Routes/routes.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const HomePage(),
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
        );
      },
    );
  }
}
