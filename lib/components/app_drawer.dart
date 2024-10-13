import 'package:driver_taxi/components/custom_alert_dialog.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/auth/auth_service.dart';
import 'package:driver_taxi/view/screen/auth/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/t.png'), // استخدم صورة مخصصة
                      fit: BoxFit.scaleDown,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 10),
                
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.orange1),
            title: Text(
              'ملفي الشخصي',
              style: TextStyle(
                color: AppColors.orange1,
                fontSize: 18,
              ),
            ),
            tileColor: Colors.grey[100], 
            onTap: () {
              Get.to(UserInfoPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.orange1),
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: AppColors.orange1,
                fontSize: 18,
              ),
            ),
            tileColor: Colors.grey[100], 
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: 'تسجيل الخروج'.tr,
                    message: 'هل انت متأكد انك تريد تسجيل الخروج'.tr,
                    cancelButtonText: 'إلغاء'.tr,
                    confirmButtonText: 'نعم, الخروج'.tr,
                    onCancel: () {
                      Get.back();
                    },
                    onConfirm: () {
                      try {
                        AuthService.logout();
                        print("Logged out successfully");
                      } catch (error) {
                        print("Error during logout: $error");
                      }
                    },
                    icon: Icons.logout,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
