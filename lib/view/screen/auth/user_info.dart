import 'dart:developer';

import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.BackgroundColor,
        title: const Text(
          'ملفي الشخصي',
          style: TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.blue1),
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: AuthService.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userData = snapshot.data!['data'];
              log(userData);
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                            width: size.width / 1.8,
                            height: size.height / 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userData['avatar'] != null &&
                                        userData['avatar'].isNotEmpty
                                    ? 'http://10.0.2.2:8000${userData['avatar']}'
                                    : 'assets/images/car1.png',
                                height: 110.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/profileImage.jpeg',
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const CustomText(
                          text: 'الاسم الكامل',
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            filled: true,
                            fillColor: AppColors.textField_color,
                          ),
                          initialValue: userData['name'],
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        const CustomText(
                          text: 'رقم الجوال',
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(Icons.phone),
                            filled: true,
                            fillColor: AppColors.textField_color,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          initialValue: userData['phone_number'] ?? 'N/A',
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        const CustomText(
                          text: 'البريد الإلكتروني',
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.textField_color,
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          initialValue: userData['email'],
                          readOnly: true,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 20),
                    // LoadingButtonWidget(
                    //   onPressed: () {
                    //     // Get.to(() => EditProfilePage(userId: '${userData['id']}'));
                    //   },
                    //   text: 'Update User Info',
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
