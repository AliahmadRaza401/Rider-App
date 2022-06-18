import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/Provider/tripProvider.dart';
import 'package:ride_star/Provider/userProvider.dart';

import 'authenticationProvider.dart';

var allProvider = [
  // ChangeNotifierProvider(create: (context) => UserProfileProvider()),
  // ChangeNotifierProvider(create: (context) => TripProvider()),
  ChangeNotifierProvider<UserProfileProvider>(
    create: (_) => UserProfileProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<TripProvider>(
    create: (_) => TripProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
    lazy: true,
  ),
];
