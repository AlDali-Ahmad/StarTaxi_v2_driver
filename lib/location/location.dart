// import 'dart:convert';
// // ignore: unused_import
// import 'dart:typed_data';
// // ignore: unused_import
// import 'package:driver_taxi/view/screen/mainscreen.dart';
// import 'package:get/get.dart';
import 'package:driver_taxi/utils/url.dart';
import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocationService {
//  static Future<void> sendLocationToDatabase() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var userId = prefs.getString('userId');
//   var token = prefs.getString('token');
//   String apiUrl =
//       '${Url.url}api/get-taxi-location/$userId';

//   try {
//     // طلب إذن الوصول إلى الموقع
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.denied) {
//       print('إذن الوصول إلى الموقع مرفوض من قبل المستخدم.');
//       return;
//     } else if (status == PermissionStatus.permanentlyDenied) {
//       print('إذن الوصول إلى الموقع مرفوض بشكل دائم. يجب تغيير الإعدادات يدويًا.');
//       await openAppSettings(); // فتح إعدادات التطبيق للسماح للمستخدم بمنح الإذن.
//       return;
//     } else if (status == PermissionStatus.granted) {
//       print('تم منح إذن الوصول إلى الموقع.');
//     }

//     // الحصول على الموقع الحالي
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     // إعداد البيانات المرسلة
//     Map<String, dynamic> payload = {
//       'lat': position.latitude,
//       'long': position.longitude,
//     };

//     // إرسال الطلب POST إلى API
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(payload),
//     );

//     // التحقق مما إذا كان الطلب ناجحًا (الرمز الحالة 200)
//     if (response.statusCode == 200) {
//       print('تم إرسال بيانات الموقع بنجاح.');
//     } else {
//       print('فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.body}');
//       print('فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
//   }
// }

//   // ignore: non_constant_identifier_names
//   static Future<void> EndsendLocationToDataBase(kilometers) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var request_id = prefs.getString('request_id');
//     var token = prefs.getString('token');
//     String apiUrl =
//         '${Url.url}api/movements/mark-completed/$request_id';

//     try {
//       // الحصول على الموقع الحالي
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // إعداد البيانات المرسلة
//       Map<String, dynamic> payload = {
//         'distance': kilometers,
//         'end_latitude': double.parse(position.latitude.toString()),
//         'end_longitude': double.parse(position.longitude.toString()),
//       };

//       // إرسال الطلب POST إلى API
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: <String, String>{
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(payload),
//       );

//       print(response.body);

//       // التحقق مما إذا كان الطلب ناجحًا (الرمز الحالة 200)
//       if (response.statusCode == 200) {
//         print('تم إرسال بيانات الموقع بنجاح.');
//         Get.off(MainScreen());
//       } else {
//         print(
//             'فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:driver_taxi/view/screen/mainscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // لإضافة Timer

class LocationService {
  static Timer? _locationTimer; // المؤقت لتحديد إرسال الموقع كل 5 ثواني

  // دالة لبدء إرسال الموقع كل 5 ثوانٍ
  static void startSendingLocationPeriodically() {
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      sendLocationToDatabase(); // إرسال الموقع كل 5 ثواني
    });
  }

  // دالة لإيقاف المؤقت
  static void stopSendingLocation() {
    _locationTimer?.cancel(); // إلغاء المؤقت
    _locationTimer = null; // إعادة تعيين المؤقت
  }

  static Future<void> sendLocationToDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('Id');
    var token = prefs.getString('token');
    String apiUrl = '${Url.url}api/get-taxi-location/$userId';

    try {
      PermissionStatus status = await Permission.location.request();
      if (status == PermissionStatus.denied) {
        print('إذن الوصول إلى الموقع مرفوض من قبل المستخدم.');
        return;
      } else if (status == PermissionStatus.permanentlyDenied) {
        print('إذن الوصول إلى الموقع مرفوض بشكل دائم.');
        await openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Map<String, dynamic> payload = {
        'lat': position.latitude,
        'long': position.longitude,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('تم إرسال بيانات الموقع بنجاح.');
      } else {
        print(response.body);
        print(
            'فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
    }
  }

  // دالة لإنهاء إرسال الموقع وإرسال البيانات النهائية
  static Future<void> EndsendLocationToDataBase(double kilometers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request_id = prefs.getString('request_id');
    var token = prefs.getString('token');
    String apiUrl = '${Url.url}api/movements/mark-completed/$request_id';

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Map<String, dynamic> payload = {
        'distance': kilometers,
        'end_latitude': double.parse(position.latitude.toString()),
        'end_longitude': double.parse(position.longitude.toString()),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('تم إرسال بيانات الموقع بنجاح.');
        stopSendingLocation();
        print('تم ايقاف الارسال ');
        Get.off(MainScreen());
      } else {
        print(
            'فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
    }
  }
}
