// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:developer';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class PusherConfig {
//   late PusherChannelsFlutter _pusher;

//   String APP_ID = "1779150";
//   String API_KEY = "ae6c2b4a7d45624809c0";
//   String SECRET = "07c8f79fe8c4af344b0c";
//   String API_CLUSTER = "eu";

//   Future<void> initPusher(onEvent, {channelName = "private-accept-request", driver_id}) async {
//     _pusher = PusherChannelsFlutter.getInstance();

//     try {
//       await _pusher.init(
//         apiKey: API_KEY,
//         cluster: API_CLUSTER,
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         authEndpoint: "http://10.0.2.2:8000/broadcasting/auth",
//         onAuthorizer: onAuthorizer,
//       );

//       try {
//         await _pusher.subscribe(
//           channelName: "$channelName.$driver_id",
//         );

//         log("trying to subscribe to :  $channelName.$driver_id");
//       } catch (e) {
//         log(e.toString());
//       }

//       await _pusher.connect();
//     } catch (e) {
//       log("error in initialization: $e");
//     }
//   }

//   void disconnect() {
//     _pusher.disconnect();
//   }

//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }

//   void onError(String message, int? code, dynamic e) {
//     log("onError: $message code: $code exception: $e");
//   }

//   void onEvent(PusherEvent event) {
//     log("onEvent: $event");
//   }

//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = _pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }

//   void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }

//   void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }

//   void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }

//   void onMemberRemoved(String channelName, PusherMember member) {
//     log("onMemberRemoved: $channelName user: $member");
//   }

//   void onSubscriptionCount(String channelName, int subscriptionCount) {
//     log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
//   }

//   dynamic onAuthorizer(
//       String channelName, String socketId, dynamic options) async {
//     log(socketId.toString());
//     // ignore: prefer_typing_uninitialized_variables
//     var json;
//     try {
//       var authUrl = 'http://10.0.2.2';
//       log('socket_id=' + socketId + '&channel_name=' + channelName);
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       var token = prefs.getString('token');

//       var result = await http.post(
//         Uri.parse(authUrl),
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//           'Authorization': 'Bearer ${token}',
//         },
//         body: 'socket_id=' + socketId + '&channel_name=' + channelName,
//       );
//       log("result: " + result.body.toString());
//       try {
//         json = jsonDecode(result.body);
//       } catch (e) {
//         return {};
//       }

//       log(json.toString());

//       return json;
//     } catch (e) {
//       log("Error :" + e.toString());
//     }
//   }
// }
