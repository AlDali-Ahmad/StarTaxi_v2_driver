import 'package:driver_taxi/core/contants/route.dart';
import 'package:driver_taxi/view/screen/auth/login.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.Login: (context) => LoginScreen1()
};
