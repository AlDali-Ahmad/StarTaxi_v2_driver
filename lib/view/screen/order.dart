import 'dart:convert';
import 'dart:developer';
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
        log('success');
        // CustomSnackbar.show(
        //   context,
        //   'تم  انهاء الرحلة الرجاء الانتظار بينما ياتيك طلب اخر '.tr,
        // );
        // Get.off(() => const MainScreen());
      } else {
        log('فشل في إرسال البيانات. الرمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      log('حدث خطأ أثناء إرسال البيانات: $e');
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
