// import 'dart:async';
// import 'dart:convert';
// import 'package:driver_taxi/utils/global.dart';
// import 'package:driver_taxi/location/location.dart';
// import 'package:driver_taxi/view/screen/order.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class Notifications extends StatefulWidget {
//   const Notifications({Key? key}) : super(key: key);

//   @override
//   State<Notifications> createState() => _NotificationsState();
// }

// class _NotificationsState extends State<Notifications> {
//   late WebSocketChannel channel;
//   var data;

//   @override
//   void initState() {
//     super.initState();
//     _connectWebSocket();
//   }

//   void _connectWebSocket() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userId = prefs.getString('userId');

//     // افتح اتصال WebSocket
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://10.0.2.2:8000/api/driver-request/$userId'),
//     );

//     // استمع للبيانات الجديدة القادمة من الخادم
//     channel.stream.listen((message) {
//       // تحليل البيانات القادمة
//       var responseBody = jsonDecode(message);
//       if (responseBody.containsKey("data")) {
//         setState(() {
//           data = responseBody["data"];
//         });

//         // حفظ البيانات في SharedPreferences
//         prefs.setString('request_id', data['request_id']);
//         prefs.setDouble('location_lat', data['location_lat']);
//         prefs.setDouble('location_long', data['location_long']);
//       }
//     }, onError: (error) {
//       print('خطأ في WebSocket: $error');
//     });
//   }

//   @override
//   void dispose() {
//     // إغلاق الاتصال عند التخلص من الصفحة
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'الاشعارات',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const Text(
//               'تفاصيل الطلب',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//               textDirection: TextDirection.rtl,
//             ),
//             data != null
//                 ? // إذا كانت البيانات متاحة
//                 Card(
//                     color: Colors.blue.shade100,
//                     child: ListTile(
//                       title: Text(
//                         "اسم الزبون: ${data['name']}",
//                         style: const TextStyle(
//                             color: Colors.black, fontSize: 16.0),
//                         textDirection: TextDirection.rtl,
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "رقم الزبون: ${data['phoneNumber']}",
//                             style: const TextStyle(
//                                 color: Colors.black, fontSize: 16.0),
//                             textDirection: TextDirection.rtl,
//                           ),
//                           Text(
//                             "موقع الزبون: ${data['customer_address']}",
//                             style: const TextStyle(
//                                 color: Colors.black, fontSize: 16.0),
//                             textDirection: TextDirection.rtl,
//                           ),
//                           Text(
//                             "نوع الرحلة: ${data['type']}",
//                             style: const TextStyle(
//                                 color: Colors.black, fontSize: 16.0),
//                             textDirection: TextDirection.rtl,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 :
//                 // إذا كانت البيانات غير متاحة
//                 Card(
//                     color: Colors.blue.shade100,
//                     child: const ListTile(
//                       title: Text(
//                         'لم تصلك طلبات بعد',
//                         textDirection: TextDirection.rtl,
//                       ),
//                     )),
//                     ElevatedButton(
//                 onPressed: () {
//                   LocationService.sendLocationToDataBase();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (c) => const Order()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: const Text("    ابدا بارسال موقعك "),
//               ),
//             if (data != null)
//               // ElevatedButton(
//               //   onPressed: () {
//               //     LocationService locationService = LocationService();
//               //     locationService.startWebSocketConnection(); // فتح الاتصال
//               //     locationService
//               //         .sendLocationRealTime(); // إرسال الموقع بشكل فوري
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(builder: (c) => const Order()),
//               //     );
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.blue,
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(25),
//               //     ),
//               //   ),
//               //   child: const Text("    ابدا بارسال موقعك "),
//               // ),
//               ElevatedButton(
//                 onPressed: () {
//                   LocationService.sendLocationToDataBase();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (c) => const Order()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: const Text("    ابدا بارسال موقعك "),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/*
//هذا الكود شغال تماما
import 'dart:async';
import 'dart:convert';
import 'package:driver_taxi/components/custom_botton.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/utils/global.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/view/screen/order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String apiUrl = '$apiPath_addition';
  var data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _startPeriodicFetch() {
    fetchData();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData();
    });
  }


Future<void> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');
  var token = prefs.getString('token');

  if (userId == null || token == null) {
    print('خطأ: لم يتم العثور على userId أو token في SharedPreferences');
    return;
  }

try {
  var response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/movements/driver-request/$userId'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);

    if (responseBody.containsKey("data") && responseBody["data"] != null) {
      data = responseBody["data"];
      print('Data: $data');

      if (data.containsKey('request_id') &&
          data.containsKey('location_lat') &&
          data.containsKey('location_long')) {
        final String idRequestId = data['request_id'].toString();
        final double locationLat = data['location_lat'] is double
            ? data['location_lat']
            : double.tryParse(data['location_lat'].toString()) ?? 0.0;
        final double locationLong = data['location_long'] is double
            ? data['location_long']
            : double.tryParse(data['location_long'].toString()) ?? 0.0;

        prefs.setString('request_id', idRequestId);
        prefs.setDouble('location_lat', locationLat);
        prefs.setDouble('location_long', locationLong);

        setState(() {});
      } else {
        print('خطأ: البيانات المستلمة لا تحتوي على الحقول المطلوبة.');
      }
    } else if (responseBody.containsKey("message")) {
      print('رسالة من السيرفر: ${responseBody["message"]}');
    } else {
      print('خطأ: لم يتم العثور على مفتاح "data" في الاستجابة.');
    }
  } else {
    print('خطأ في الاستجابة من السيرفر: ${response.statusCode}');
  }
} catch (error) {
  print('خطأ في جلب البيانات: $error');
}


}

  // Future<void> fetchData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userId = prefs.getString('userId');
  //   var token = prefs.getString('token');
  //   try {
  //     var response = await http.get(
  //       Uri.parse('http://10.0.2.2:8000/api/movements/driver-request/$userId'),
  //       headers: <String, String>{
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${token}'
  //       },
  //     );
  //     var responseBody = jsonDecode(response.body);
  //     print('llll:${responseBody}');
  //     if (responseBody.containsKey("data")) {
  //       data = responseBody["data"];
  //       print(data['request_id'].runtimeType);
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final Map<String, dynamic> responseData = json.decode(response.body);
  //         final String idRequest_id = responseData['data']['request_id'];
  //         final double location_lat = responseData['data']['location_lat'];
  //         final double location_long = responseData['data']['location_long'];
  //         final SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setString('request_id', idRequest_id);
  //         prefs.setDouble('location_lat', location_lat);
  //         prefs.setDouble('location_long', location_long);
  //       }
  //       setState(() {});
  //     }
  //   } catch (error) {
  //     print('خطأ في جلب البيانات: $error');
  //     setState(() {});
  //   }
  // }

  void _startPeriodicSendLocation() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      LocationService.sendLocationToDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final LocationService _locationService = LocationService();
    return Scaffold(
      appBar: AppBar(
        title:CustomText(
          text:'My Orders',
          fontSize: 18.sp,
          color: Colors.white,
        ),
         backgroundColor: AppColors.orange1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            data != null
                ? Column(
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange1,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Card(
                        color: Colors.blue.shade100,
                        child: ListTile(
                          title: Text(
                            "اسم الزبون: ${data['name']}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16.0),
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "رقم الزبون: ${data['phone_number']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "موقع الزبون: ${data['customer_address']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textDirection: TextDirection.rtl,
                              ),
                              // إضافة بيانات إضافية هنا بنفس التنسيق والحجم
                              Text(
                                "نوع الرحلة: ${data['type']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "location_long : ${data['location_long']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "location_lat ${data['location_lat']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Card(
                    color: AppColors.BackgroundColor,
                    margin: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: AppColors.orange2),
                    ),
                    elevation: 5,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'No Order Now!',
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  ),
            if (data != null) // إذا كانت البيانات متاحة
              CustomButton(
                width: 220.w,
                onPressed: () {
                  LocationService.sendLocationToDatabase();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const Order()),
                  );
                },
                text: "Start Send Location",
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}*/






/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebSocket Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebSocketListener(),
    );
  }
}

class WebSocketListener extends StatefulWidget {
  const WebSocketListener({super.key});

  @override
  _WebSocketListenerState createState() => _WebSocketListenerState();
}

class _WebSocketListenerState extends State<WebSocketListener> {
  late WebSocketChannel _channel;
  String _receivedMessage = 'No message received yet';
  final String _token =
      '23|ZdEqfb4jqPDC6Mz8sxV77Ltmd3u46knkEf7FXcXh6fa5045a'; // استبدل برمز الوصول الخاص بك
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Connect to the WebSocket
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1'),
    );

    // Listen to the WebSocket stream
    _channel.stream.listen(
      (event) async {
        print('Received event: $event');

        // Handle the connection established event
        if (event.contains('connection_established')) {
          final decodedEvent = jsonDecode(event);
          final decodeData = jsonDecode(decodedEvent['data']);
          final socketId = decodeData['socket_id'];

          // Authenticate with Laravel broadcasting/auth endpoint
          const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
          final authResponse = await http.post(
            Uri.parse(authUrl),
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'channel_name': 'send-message.30d0483d-f616-4f01-9b53-38e292999757',
              'socket_id': "$socketId"
            }),
          );

          if (authResponse.statusCode == 200) {
            final authData = jsonDecode(authResponse.body);
            // Subscribe to the private channel with the auth signature
            _channel.sink.add(jsonEncode({
              "event": "pusher:subscribe",
              "data": {
                "channel": "send-message.30d0483d-f616-4f01-9b53-38e292999757",
                "auth": authData['auth'].toString(),
              },
            }));
          } else {
            print('Failed to authenticate: ${authResponse.body}');
          }
        }

        // Decode and handle other events
        try {
          final decodedEvent = jsonDecode(event);
          if (decodedEvent is Map<String, dynamic>) {
            print(decodedEvent);

            if (decodedEvent.containsKey('event') &&
                decodedEvent['event'] == 'sendMessage') {
              setState(() {
                final decodedData = jsonDecode(decodedEvent['data']);
                _receivedMessage = decodedData['message'];
              });
            }
          } else {
            print('Unexpected data format: $decodedEvent');
          }
        } catch (e) {
          print('Error decoding event: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      cancelOnError: true,
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Send message to Laravel
      _channel.sink.add(jsonEncode({
        'event': 'location.updated', // Event name
        'channel': 'test.3473d276-df6f-4eb8-be0e-283ade38cb1a', // Channel name
        'data': {
          'message': _messageController.text,
        },
      }));

      // Clear the text field after sending
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _messageController.dispose(); // Dispose the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Listener'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _receivedMessage,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Type your message here',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: const Text('Send Message'),
          ),
        ],
      ),
    );
  }
}

 */














import 'dart:async';
import 'dart:convert';
import 'package:driver_taxi/components/custom_botton.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/utils/global.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/view/screen/auth/UserPreference.dart';
import 'package:driver_taxi/view/screen/order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String apiUrl = '$apiPath_addition';
  var data;
  bool isLoading = true;
  GoogleMapController? gms;
  List<Marker> markers = [];
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(33.504307, 36.304141),
    zoom: 10.4746,
  );

  @override
  void initState() {
    super.initState();
    fetchData();
    loadUserData();
  }

  late WebSocketChannel _channel;
  bool _isSnackbarVisible = false;
  String? id;
  String? _token;
  String? _customer_id;
  String? _chat_id;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectDelay = Duration(seconds: 5);
  Future<void> loadUserData() async {
    Map<String, String?> userInfo = await UserPreferences.getUserInfo();
    setState(() {
      id = userInfo['id'];
      _token = userInfo['token'];
      _chat_id = userInfo['chat_id'];
      _customer_id = userInfo['customer_id'];
      if (id != null &&
          _token != null &&
          _customer_id != null &&
          _customer_id != null) {
        _connectToWebSocket();
        // _connectToWebSocket2();
        print('id:${id}');
        print('_token:${_token}');
        print('_chat_id:${_chat_id}');
        print('_customer_id:${_customer_id}');
      } else {
        print('Failed to load user data: id or token is null');
      }
    });
  }

  void _connectToWebSocket() {
    _reconnectAttempts = 0;
    _channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1',
      ),
    );

    _channel.stream.listen(
      (event) async {
        print('Received event: $event');

        // إذا تم تأسيس الاتصال
        if (event.contains('connection_established')) {
          final decodedEvent = jsonDecode(event);
          final decodeData = jsonDecode(decodedEvent['data']);
          final socketId = decodeData['socket_id'];
          print('Socket ID 5551: $socketId');

          const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
          final authResponse = await http.post(
            Uri.parse(authUrl),
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(
              {
                'channel_name': 'send-message.${_chat_id}',
                'socket_id': socketId
              },
            ),
          );

          if (authResponse.statusCode == 200) {
            final authData = jsonDecode(authResponse.body);
            print('Auth data: $authData');
            _channel.sink.add(jsonEncode({
              "event": "pusher:subscribe",
              "data": {
                "channel": "send-message.${_chat_id}",
                "auth": authData['auth'].toString(),
              },
            }));
          } else {
            print('Failed to authenticate: ${authResponse.body}');
          }
        }

        // معالجة الأحداث الأخرى
        try {
          final decodedEvent = jsonDecode(event);
          print('Decoded event3231: $decodedEvent');
          if (decodedEvent is Map<String, dynamic>) {
            print('Decoded event:212121 $decodedEvent');

            if (decodedEvent.containsKey('event') &&
                decodedEvent['event'] == 'sendMessage') {
              print('Decoded event:3131313 $decodedEvent');
              if (mounted) {
                setState(() {
                  final data = jsonDecode(decodedEvent['data']);
                  print(data);

                  Get.snackbar(
                    "",
                    'sssssssssssssssssss'.tr,
                    colorText: AppColors.white,
                  );
                  // playNotificationSound();
                });
              }
            }
          }
        } catch (e) {
          print('Error decoding event: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
        _reconnect();
      },
      cancelOnError: true,
    );
  }

  void _reconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      print('Attempting to reconnect... ($_reconnectAttempts)');
      Future.delayed(_reconnectDelay, () {
        _connectToWebSocket();
      });
    } else {
      print('Max reconnect attempts reached. Giving up.');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    // _channel2.sink.close();
    super.dispose();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('Id');
    var token = prefs.getString('token');
    print(userId);
    print(token);

    if (userId == null || token == null) {
      print('خطأ: لم يتم العثور على userId أو token في SharedPreferences');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/movements/driver-request/$userId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);

        // تحقق من وجود المفتاح "data" في الـ responseBody
        if (responseBody != null && responseBody.isNotEmpty) {
          setState(() {
            data = responseBody;
          });
          print('Data: $data');

          // حفظ المعلومات في SharedPreferences
          await prefs.setString('request_id', data['request_id']);
          await prefs.setString('chat_id', data['chat_id']);
          await prefs.setString('customer_id', data['customer_id']);
          await prefs.setDouble('price', data['price'].toDouble());
          await prefs.setString('typeMov', data['type']);
          await prefs.setString('is_onKM', data['is_onKM'].toString());

          // التعامل مع الموقع وإضافة الـ Marker
          final double locationLat = data['location_lat'] is double
              ? data['location_lat']
              : double.tryParse(data['location_lat'].toString()) ?? 0.0;
          final double locationLong = data['location_long'] is double
              ? data['location_long']
              : double.tryParse(data['location_long'].toString()) ?? 0.0;

          if (locationLat != 0.0 && locationLong != 0.0) {
            setState(() {
              markers.add(Marker(
                markerId: const MarkerId('customerLocation'),
                position: LatLng(locationLat, locationLong),
                infoWindow: InfoWindow(
                  title: 'Customer Location',
                  snippet: 'Lat: $locationLat, Long: $locationLong',
                ),
              ));

              cameraPosition = CameraPosition(
                target: LatLng(locationLat, locationLong),
                zoom: 14.0,
              );

              if (gms != null) {
                gms!.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition),
                );
              }
            });
          } else {
            print('خطأ: إحداثيات الموقع غير صالحة');
          }
        } else {
          print('خطأ: البيانات غير موجودة');
        }
      } else {
        print('خطأ في الاستجابة: ${response.statusCode}');
      }
    } catch (error) {
      print('خطأ في جلب البيانات: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.orange1, AppColors.orange2],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: AppBar(
            title: CustomText(
              text: 'طلباتي',
              fontSize: 18.sp,
              color: Colors.white,
              alignment: Alignment.topRight,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange1),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  data != null
                      ? Column(
                          children: [
                            const Text(
                              'تفاصيل الطلب',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orange1,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 5.h),
                            Card(
                              color: AppColors.BackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side:
                                    const BorderSide(color: AppColors.orange1),
                              ),
                              child: ListTile(
                                title: Text(
                                  "اسم الزبون: ${data['name'].toString()}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  // textDirection: TextDirection.rtl,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text:
                                          "رقم الزبون: ${data['phone_number'].toString()}",
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                    CustomText(
                                      text:
                                          "موقع الزبون: ${data['customer_address'].toString()}",
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                    CustomText(
                                      text:
                                          "نوع الرحلة: ${data['type'].toString()}",
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 300.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: GoogleMap(
                                  markers: markers.toSet(),
                                  initialCameraPosition: cameraPosition,
                                  mapType: MapType.normal,
                                  onMapCreated: (mapController) {
                                    gms = mapController;
                                  },
                                  onTap: (LatLng latLng) {
                                    markers.add(
                                      Marker(
                                        markerId: const MarkerId("1"),
                                        position: LatLng(
                                            latLng.latitude, latLng.longitude),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                          ],
                        )
                      : Card(
                          color: AppColors.BackgroundColor,
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: AppColors.orange2),
                          ),
                          elevation: 5,
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CustomText(
                              text: 'لا يوجد بيانات',
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                  if (data != null)
                    CustomButton(
                      width: 220.w,
                      onPressed: () {
                        LocationService.startSendingLocationPeriodically();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) => const Order()),
                        );
                      },
                      text: "ابدأ رحلتك",
                    )
                ],
              ),
            ),
    );
  }
}
