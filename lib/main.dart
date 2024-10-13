import 'package:driver_taxi/test.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/auth/login.dart';
import 'package:driver_taxi/view/screen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SharedPreferences? sharepref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharepref = await SharedPreferences.getInstance();
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: Locale('ar'),
      theme: ThemeData(
        fontFamily:'Cairo',
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.BackgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: CheckLogin(),
      // home: TestRealTime(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
      Get.off(MainScreen());
    } else {
      Get.off(LoginScreen1());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
