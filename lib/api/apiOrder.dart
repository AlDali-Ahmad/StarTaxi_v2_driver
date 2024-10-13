import 'dart:convert';
import 'package:driver_taxi/utils/global.dart';
import 'package:http/http.dart' as http;

class ApiOrder {
  static Future<void> foundCustomer() async {
    try {
      String apiUrl = '$apiPath_OrderStatus'; 
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'status': 'found_customer'}), 
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // التحقق من رمز الاستجابة
      if (response.statusCode == 200) {
        print('Order status updated successfully to found customer');
      } else {
        // في حالة عدم نجاح الطلب
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      // في حالة حدوث أي استثناء أثناء إرسال الطلب
      print('Error updating order status: $e');
    }
  }

  // دالة لتحديث حالة الطلب إلى "لم يتم العثور"
  static Future<void> notFoundCustomer() async {
    try {
      String apiUrl = '$apiPath_OrderStatus'; 

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'status': 'not_found_customer'}), // جسم الطلب
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // التحقق من رمز الاستجابة
      if (response.statusCode == 200) {
        print('Order status updated successfully to not found customer');
      } else {
        // في حالة عدم نجاح الطلب
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      // في حالة حدوث أي استثناء أثناء إرسال الطلب
      print('Error updating order status: $e');
    }
  }
}
