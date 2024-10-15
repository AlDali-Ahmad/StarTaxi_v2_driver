import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driver_taxi/components/customTextField.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/components/custom_botton.dart';
import 'package:driver_taxi/components/custom_snackbar.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/utils/global.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/mainscreen.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen1 extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// عند تسجيل الدخول بنجاح

class _LoginScreenState extends State<LoginScreen1> {
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    // checkVisibilityKeyboard();
    // checkLocationPermission();
    // checkLoginStatus();
  }

  // Future<void> checkLoginStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   if (isLoggedIn) {
  //     Get.off(() => const MainScreen());
  //   }
  // }

  // دالة للتحقق من حالة إذن الوصول إلى الموقع
  // Future<void> checkLocationPermission() async {
  //   final status =
  //       await Permission.locationWhenInUse.status; // الحصول على حالة الإذن
  //   if (status == PermissionStatus.granted) {
  //     // إذا تمت الموافقة على الإذن، يمكنك هنا القيام بأي شيء يتطلب الوصول إلى الموقع
  //     print('تمت الموافقة على الوصول إلى الموقع');
  //   } else if (status == PermissionStatus.denied ||
  //       status == PermissionStatus.permanentlyDenied) {
  //     // إذا تم رفض الإذن أو تم رفضه بشكل دائم، يمكنك هنا تنبيه المستخدم لضرورة منح الإذن
  //     print('لم يتم منح إذن الوصول إلى الموقع');
  //   }
  // }

  // TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibilityKeyboard = false;
  int logoSize = 150;

  bool _showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (!isValidEmail(email)) {
      CustomSnackbar.show(
        context,
        'البريد الإلكتروني غير صحيح',
      );
      return;
    }

    if (password.isEmpty) {
      CustomSnackbar.show(
        context,
        'الرجاء إدخال كلمة مرور',
      );
      return;
    }

    if (password.length < 8) {
      CustomSnackbar.show(
        context,
        'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
      );
      return;
    }
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final Uri url = Uri.parse('$apiPathLogin');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.show(
          context,
          'تم  تسجيل الدخول بنجاح'.tr,
        );
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String id = responseData['data']['user']['id'];
        final String currentEmail = responseData['data']['user']['email'];
        final String mail_code_verified_at =
            responseData['data']['user']['mail_code_verified_at'];
        print(id);
        print(token);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('Id', id);
        prefs.setString('token', token);
        Get.off(MainScreen());
      } else if (response.statusCode == 422) {
        print(response.statusCode);
        Get.snackbar(
          'خطأ',
          'هناك خطأ بالبيانات الرجاء التحقق من البريد الإلكتروني وكلمة المرور'
              .tr, 
          snackPosition:
              SnackPosition.BOTTOM, 
          backgroundColor: Colors.red.withOpacity(0.8), 
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else if (response.statusCode == 403) {
        print(response.statusCode);
        Get.snackbar(
          'خطأ', 
          'هذا السائق لا يمتلك تاكسي'.tr, 
          snackPosition:
              SnackPosition.BOTTOM, 
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3), 
        );
      }
    } catch (error) {
      print('حدث خطأ : $error');
    }
  }

  // void checkVisibilityKeyboard() {
  //   KeyboardVisibilityController _keyboardVisibilityController =
  //       KeyboardVisibilityController();
  //   _keyboardVisibilityController.onChange.listen((bool visible) {
  //     if (mounted) {
  //       setState(() {
  //         visibilityKeyboard = visible;
  //         logoSize = visible ? 100 : 150;
  //       });
  //     }
  //   });
  // }
  // void _startPeriodicSendLocation() {
  //   Timer.periodic(Duration(seconds: 5), (timer) {
  //     LocationService.sendLocationToDataBase(); // استدعاء دالة إرسال الموقع
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    // final LocationService _locationService = LocationService();
    // var size = MediaQuery.of(context).size;
    // Get.lazyPut<AuthController>(() => AuthController());
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car1.png", height: 70.h),
                    const CustomText(
                      text: 'صفحة تسجبل الدخول',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      alignment: Alignment.center,
                      color: AppColors.iconColor,
                    ),
                    SizedBox(height: 30.h),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'ادخل بريدك الاكتروني',
                      iconData: Icons.email,
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمة المرور الخاصة بك',
                        hintStyle:
                            TextStyle(color: Colors.grey), 
                        prefixIcon:
                            Icon(Icons.lock, color: AppColors.iconColor),
                        filled: true,
                        fillColor: AppColors.textField_color,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.iconColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black), 
                      obscureText: !_showPassword,
                    ),
                    SizedBox(height: 25.h),
                    LoadingButtonWidget(
                      text: 'تسجيل الدخول',
                      onPressed: loginUser,
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'dart:async';
import 'dart:convert';
import 'package:driver_taxi/components/customTextField.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/components/custom_snackbar.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/global/global.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/mainscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen1 extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// عند تسجيل الدخول بنجاح

class _LoginScreenState extends State<LoginScreen1> {
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    checkVisibilityKeyboard();
    checkLocationPermission();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Get.off(() => const MainScreen());
    }
  }

  // دالة للتحقق من حالة إذن الوصول إلى الموقع
  Future<void> checkLocationPermission() async {
    final status =
        await Permission.locationWhenInUse.status; // الحصول على حالة الإذن

    if (status == PermissionStatus.granted) {
      // إذا تمت الموافقة على الإذن، يمكنك هنا القيام بأي شيء يتطلب الوصول إلى الموقع
      print('تمت الموافقة على الوصول إلى الموقع');
    } else if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      // إذا تم رفض الإذن أو تم رفضه بشكل دائم، يمكنك هنا تنبيه المستخدم لضرورة منح الإذن
      print('لم يتم منح إذن الوصول إلى الموقع');
    }
  }

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibilityKeyboard = false;
  int logoSize = 150;

  bool _showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (!isValidEmail(email)) {
      CustomSnackbar.show(
        context,
        'البريد الإلكتروني غير صحيح',
      );
      return;
    }

    if (password.isEmpty) {
      CustomSnackbar.show(
        context,
        'الرجاء إدخال كلمة مرور',
      );
      return;
    }

    if (password.length < 8) {
      CustomSnackbar.show(
        context,
        'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
      );
      return;
    }
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final Uri url = Uri.parse('$apiPathLogin');

    try {
      // ignore: unused_local_variable
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.show(
          // ignore: use_build_context_synchronously
          context,
          'تم  تسجيل الدخول بنجاح'.tr,
        );
        Get.off(() => const MainScreen());
        // Get.off(() => const Test());
        // ignore: unused_local_variable
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String id = responseData['data']['user']['id'];
        final String token = responseData['data']['token'];
        print(id);
        print(token);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // تخزين حالة تسجيل الدخول بنجاح

        prefs.setString('userId', id);
        prefs.setString('token', token);
      } else if (response.statusCode == 422) {
        print(response.statusCode);
        // حدث خطأ في البريد الإلكتروني أو كلمة المرور
        CustomSnackbar.show(
          context,
          'هناك خطا بالبيانات الرجاء التحقق من البريد الاكتروني و كلمة المرور'
              .tr,
        );
      }
    } catch (error) {
      print('حدث خطأ : $error');
    }
  }

  void checkVisibilityKeyboard() {
    KeyboardVisibilityController _keyboardVisibilityController =
        KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          visibilityKeyboard = visible;
          logoSize = visible ? 100 : 150;
        });
      }
    });
  }

  // void _startPeriodicSendLocation() {
  //   Timer.periodic(Duration(seconds: 5), (timer) {
  //     LocationService.sendLocationToDataBase(); // استدعاء دالة إرسال الموقع
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final LocationService _locationService = LocationService();
    var size = MediaQuery.of(context).size;
    // Get.lazyPut<AuthController>(() => AuthController());
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car1.png", height: 70.h),
                    const CustomText(
                      text: 'Login Page',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.iconColor,
                    ),
                    SizedBox(height: size.height / 30),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter your Email',
                      iconData: Icons.email,
                    ),
                    SizedBox(height: size.height / 30),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        prefixIcon:
                            Icon(Icons.lock, color: AppColors.iconColor),
                        filled: true,
                        fillColor: AppColors.textField_color,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: !_showPassword,
                    ),
                    SizedBox(height: size.height / 25),
                    LoadingButtonWidget(
                      text: 'Login',
                      onPressed: loginUser,
                    ),
                    SizedBox(height: size.height / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "Don't have an account?",
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(() => const RegisterPage());
                          },
                          child: const CustomText(
                            text: 'Create an account',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8DD2C9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 */