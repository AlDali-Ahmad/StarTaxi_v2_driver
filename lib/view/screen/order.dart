// import 'dart:convert';
// import 'dart:ui' as ui;
// import 'package:driver_taxi/components/custom_botton.dart';
// import 'package:driver_taxi/components/custom_loading_button.dart';
// import 'package:driver_taxi/components/custom_snackbar.dart';
// import 'package:driver_taxi/location/location.dart';
// import 'package:driver_taxi/utils/app_colors.dart';
// import 'package:driver_taxi/view/screen/mainscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Order extends StatefulWidget {
//   const Order({Key? key}) : super(key: key);

//   @override
//   State<Order> createState() => _OrderState();
// }

// class _OrderState extends State<Order> {
//   bool _isOnDuty = true;
//   double _price = 0.0;
//   bool _isInternalRequest = true;

//   final TextEditingController _kilometersController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   @override
//   void dispose() {
//     _kilometersController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userId = prefs.getString('userId');
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:8000/api/movements/driver-request/$userId'),
//         headers: <String, String>{
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       );

//       var responseBody = jsonDecode(response.body);

//       if (responseBody.containsKey("data")) {
//         // ignore: unused_local_variable
//         var data = responseBody["data"];

//         if (response.statusCode == 200 || response.statusCode == 201) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           final String type = responseData['data']['type'];
//           final String is_onKM = responseData['data']['is_onKM'];
//           final String price = responseData['data']['price'];
//           print('price : ${price}');
//           setState(() {
//             _isInternalRequest = (type == 'طلب داخلي');
//             if (!_isInternalRequest) {
//               double kilometers = double.tryParse(is_onKM) ?? 0.0;
//               double priceNum = double.tryParse(price) ?? 0.0;
//               _price = kilometers * priceNum;
//             }
//           });

//           prefs.setString('is_onKM', is_onKM);
//         }
//       }
//     } catch (error) {
//       print('خطأ في جلب البيانات: $error');
//     }
//   }

//   Future<void> sendStatusToDataBase(bool isOnDuty) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var Request_id = prefs.getString('request_id');
//     var token = prefs.getString('token');
//     int stateParam = isOnDuty ? 1 : 0;
//     final Map<String, dynamic> data = {
//       'state': stateParam, // تعيين قيمة الـ state هنا
//     };
//     // String apiUrl = '$apiPath_OrderStatus';

//     try {
//       // إرسال الطلب POST إلى API
//       final response = await http.post(
//         Uri.parse(
//             'http://10.0.2.2:8000/api/movements/found-customer/${Request_id}'),
//         headers: <String, String>{
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(data),
//       );
//       print(Request_id);

//       print(response.body);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         CustomSnackbar.show(
//           // ignore: use_build_context_synchronously
//           context as BuildContext,
//           'تم  انهاء الرحلة الرجاء الانتظار بينما ياتيك طلب اخر  '.tr,
//         );
//         Get.off(() => const MainScreen());
//       }
//       // التحقق مما إذا كان الطلب ناجحًا وطباعة رسالة بالتبليغ
//       if (response.statusCode == 200) {
//         print('تم إرسال البيانات بنجاح.');
//       } else {
//         print('فشل في إرسال البيانات. الرمز الحالة: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء إرسال البيانات: $e');
//     }
//   }

//   // void _goToMaps() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   double location_lat = prefs.getDouble('location_lat') ?? 36.583950;
//   //   double location_long = prefs.getDouble('location_long') ?? 37.039161;

//   //   String locationUrl =
//   //       'https://www.google.com/maps/search/?api=1&query=$location_lat,$location_long';
//   //   final String encodedUrl = Uri.encodeFull(locationUrl);
//   //   if (await canLaunch(encodedUrl)) {
//   //     await launch(encodedUrl);
//   //   } else {
//   //     print('Could not launch $encodedUrl');
//   //     throw 'Could not launch $encodedUrl';
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Order Page',
//           style: TextStyle(color: Colors.amber),
//         ),
//         backgroundColor: AppColors.BackgroundColor,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 LoadingButtonWidget(
//                   width: 150.w,
//                   height: 35.h,
//                   onPressed: () {
//                     setState(() {
//                       _isOnDuty = true;
//                       sendStatusToDataBase(_isOnDuty);
//                     });
//                   },
//                   borderColor: _isOnDuty ? AppColors.orange2 : AppColors.grey,
//                   backgroundColor1:
//                       _isOnDuty ? AppColors.orange1 : AppColors.white,
//                   backgroundColor2:
//                       _isOnDuty ? AppColors.orange2 : AppColors.white,
//                   textColor:
//                       _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                   fontSize: 12,
//                   lodingColor:
//                       _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                   text: 'تم العثور على الزبون',
//                 ),
//                 LoadingButtonWidget(
//                   width: 150.w,
//                   height: 35.h,
//                   onPressed: () {
//                     setState(() {
//                       _isOnDuty = false;
//                       sendStatusToDataBase(_isOnDuty);
//                     });
//                   },
//                   borderColor: _isOnDuty ? AppColors.grey : AppColors.orange2,
//                   backgroundColor1:
//                       _isOnDuty ? AppColors.white : AppColors.orange1,
//                   backgroundColor2:
//                       _isOnDuty ? AppColors.white : AppColors.orange2,
//                   textColor:
//                       _isOnDuty ? AppColors.BackgroundColor : AppColors.white,
//                   fontSize: 12,
//                   lodingColor:
//                       _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                   text: 'لم يتم العثور على الزبون',
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomButton(
//                   width: 295.h,
//                   height: 35.h,
//                   onPressed: () {},
//                   background_color1: AppColors.white,
//                   background_color2: AppColors.white,
//                   border_color: AppColors.grey,
//                   text: 'السعر: $_price',
//                   textColor: AppColors.BackgroundColor,
//                 ),
//                 // LoadingButtonWidget(
//                 //   width: 150.w,
//                 //   height: 35.h,
//                 //   onPressed: () {
//                 //     _goToMaps();
//                 //   },
//                 //   text: 'الانتقال اى موقع الزبون',
//                 // ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _kilometersController,
//               decoration: InputDecoration(
//                 hintText: '  كيلومترات',
//                 suffixIcon: const Icon(
//                   Icons.directions_car,
//                   color: ui.Color.fromARGB(95, 0, 0, 0),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.black12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               onChanged: (value) async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 setState(() {
//                   print(prefs.getString('price'));
//                   if (_isInternalRequest) {
//                     _price =
//                         double.tryParse(prefs.getString('price') ?? '1.0') ??
//                             0.0;
//                   } else {
//                     double kilometers = double.tryParse(value) ?? 0.0;
//                     double price =
//                         double.tryParse(prefs.getString('price') ?? '1.0') ??
//                             0.0;
//                     _price = kilometers * price;
//                   }
//                 });
//               },
//               // onChanged: (value) async {
//               //   setState(() async {
//               //     SharedPreferences prefs =
//               //         await SharedPreferences.getInstance();
//               //     if (_isInternalRequest) {
//               //       _price =
//               //           double.tryParse(prefs.getString('price') ?? '1.0') ??
//               //               0.0;
//               //     } else {
//               //       double kilometers = double.tryParse(value) ?? 0.0;
//               //       double price =
//               //           double.tryParse(prefs.getString('price') ?? '1.0') ??
//               //               0.0;
//               //       _price = kilometers * price;
//               //     }
//               //   } as Null Function());
//               // },
//             ),
//             Spacer(),
//             CustomButton(
//               onPressed: () {
//                 double kilometers =
//                     double.tryParse(_kilometersController.text) ?? 1.0;
//                 LocationService.EndsendLocationToDataBase(kilometers);
//                 _kilometersController.clear();
//                 Get.off(MainScreen());
//               },
//               text: 'قم بانهاء الرحلة',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:driver_taxi/components/custom_botton.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool _isOnDuty = true;
  double _price = 0.0;
  // final bool _isInternalRequest = true;
  final TextEditingController _kilometersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  @override
  void dispose() {
    _kilometersController.dispose();
    super.dispose();
  }

  // Future<void> fetchData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userId = prefs.getString('userId');
  //   try {
  //     var response = await http.get(
  //       Uri.parse('http://10.0.2.2:8000/api/movements/driver-request/$userId'),
  //       headers: <String, String>{
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     var responseBody = jsonDecode(response.body);
  //     if (responseBody.containsKey("data")) {
  //       var data = responseBody["data"];
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final String type = data['type'];
  //         final String is_onKM = data['is_onKM'];
  //         final double price = data['price'];
  //         // طباعة البيانات للتحقق
  //         print('نوع الطلب: $type');
  //         print('المسافة بالكيلومترات: $is_onKM');
  //         print('السعر لكل كيلومتر: $price');
  //         setState(() {
  //           _isInternalRequest = (type == 'طلب داخلي');
  //           if (!_isInternalRequest) {
  //             double kilometers = double.tryParse(is_onKM) ?? 0.0;
  //             double priceNum = price ?? 0.0;
  //             _price = kilometers * priceNum;
  //           }
  //         });
  //       }
  //     }
  //   } catch (error) {
  //     print('خطأ في جلب البيانات: $error');
  //   }
  // }

  Future<void> sendStatusToDataBase(bool isOnDuty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var requestId = prefs.getString('request_id');
    var token = prefs.getString('token');
    int stateParam = isOnDuty ? 1 : 0;
    final Map<String, dynamic> data = {
      'state': stateParam,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8000/api/movements/found-customer/$requestId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('success');
        // CustomSnackbar.show(
        //   context,
        //   'تم  انهاء الرحلة الرجاء الانتظار بينما ياتيك طلب اخر '.tr,
        // );
        // Get.off(() => const MainScreen());
      } else {
        print('فشل في إرسال البيانات. الرمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال البيانات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'صفحة الطلب',
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: AppColors.BackgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadingButtonWidget(
                  width: 150.w,
                  height: 35.h,
                  onPressed: () {
                    setState(() {
                      _isOnDuty = true;
                      sendStatusToDataBase(_isOnDuty);
                    });
                  },
                  borderColor: _isOnDuty ? AppColors.orange2 : AppColors.grey,
                  backgroundColor1:
                      _isOnDuty ? AppColors.orange1 : AppColors.white,
                  backgroundColor2:
                      _isOnDuty ? AppColors.orange2 : AppColors.white,
                  textColor:
                      _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
                  fontSize: 12,
                  lodingColor:
                      _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
                  text: 'تم العثور على الزبون',
                ),
                LoadingButtonWidget(
                  width: 150.w,
                  height: 35.h,
                  onPressed: () {
                    setState(() {
                      _isOnDuty = false;
                      sendStatusToDataBase(_isOnDuty);
                    });
                  },
                  borderColor: _isOnDuty ? AppColors.grey : AppColors.orange2,
                  backgroundColor1:
                      _isOnDuty ? AppColors.white : AppColors.orange1,
                  backgroundColor2:
                      _isOnDuty ? AppColors.white : AppColors.orange2,
                  textColor:
                      _isOnDuty ? AppColors.BackgroundColor : AppColors.white,
                  fontSize: 12,
                  lodingColor:
                      _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
                  text: 'لم يتم العثور على الزبون',
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  width: 295.h,
                  height: 35.h,
                  onPressed: () {},
                  background_color1: AppColors.white,
                  background_color2: AppColors.white,
                  border_color: AppColors.grey,
                  text: 'السعر: $_price',
                  textColor: AppColors.BackgroundColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _kilometersController,
              decoration: InputDecoration(
                hintText: '  كيلومترات',
                suffixIcon: const Icon(
                  Icons.directions_car,
                  color: ui.Color.fromARGB(95, 0, 0, 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var typeMov = prefs.getString('typeMov');
                bool _isInternalRequest = typeMov != 'طلب خارجي'; 
                setState(() {
                  if (_isInternalRequest) {
                    _price = prefs.getDouble('price') ?? 1.0;
                  } else {
                    double kilometers = double.tryParse(value) ?? 0.0;
                    double price = prefs.getDouble('price') ?? 1.0;
                    _price = kilometers * price;
                  }
                });
              },
            ),
            const Spacer(),
            LoadingButtonWidget(
              onPressed: () {
                double kilometers =
                    double.tryParse(_kilometersController.text) ?? 1.0;
                LocationService.EndsendLocationToDataBase(kilometers);
                _kilometersController.clear();
              },
              text: 'قم بانهاء الرحلة',
            )
          ],
        ),
      ),
    );
  }
}
