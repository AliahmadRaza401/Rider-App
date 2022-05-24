import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/Provider/tripProvider.dart';

import 'authenticationProvider.dart';

final allProvider = [
  ChangeNotifierProvider(create: (context) => UserProfileProvider()),
  ChangeNotifierProvider(create: (context) => TripProvider()),
];
