import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:driver_taxi/components/custom_password_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driver_taxi/components/customTextField.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/components/custom_snackbar.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/utils/global.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/mainscreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen1 extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen1> {
  // bool isValidEmail(String email) {
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   return emailRegex.hasMatch(email);
  // }

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
  bool visibilityKeyboard = false;
  int logoSize = 150;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final Uri url = Uri.parse(apiPathLogin);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      log(response.body);
      log('${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.show(
          context,
          'تم  تسجيل الدخول بنجاح'.tr,
        );
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String id = responseData['data']['user']['id'];
        // final String currentEmail = responseData['data']['user']['email'];
        // final String mail_code_verified_at =
        responseData['data']['user']['mail_code_verified_at'];
        log(id);
        log(token);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('Id', id);
        prefs.setString('token', token);
        Get.off(const MainScreen());
      } else if (response.statusCode == 422) {
        log('${response.statusCode}');
        Get.snackbar(
          'خطأ',
          'هناك خطأ بالبيانات الرجاء التحقق من البريد الإلكتروني وكلمة المرور'
              .tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else if (response.statusCode == 403) {
        log('${response.statusCode}');
        Get.snackbar(
          'خطأ',
          'هذا السائق لا يمتلك تاكسي'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      log('حدث خطأ : $error');
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
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
                        hintText: 'enter_your_email'.tr,
                        iconData: Icons.email,
                        iconColor: AppColors.iconColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'.tr;
                          }
                          final emailRegex =
                              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomPasswordField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'.tr;
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long'
                                .tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      LoadingButtonWidget(
                        text: 'تسجيل الدخول',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            loginUser();
                          }
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
