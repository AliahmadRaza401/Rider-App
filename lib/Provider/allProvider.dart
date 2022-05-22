import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticationProvider.dart';

final allProvider = [
  ChangeNotifierProvider(create: (context) => UserProfileProvider()),
];
