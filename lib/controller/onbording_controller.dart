// import 'package:driver_taxi/core/contants/route.dart';
// import 'package:driver_taxi/data/datasource/static/static.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// abstract class OnBoardingController extends GetxController {
//   next();
//   onPageChanged(int index);
// }

// class OnBoardingControllerImp extends OnBoardingController {
//   @override
//   // ignore: override_on_non_overriding_member
//   int currentPage = 0;
//   late PageController pageController;

//   @override
//   next() {
//     currentPage++;
//     if (currentPage > onBoardingList.length - 1) {
//       Get.offAllNamed(AppRoute.Login);
//     } else {
//       pageController.animateToPage(currentPage,
//           duration: const Duration(microseconds: 900), curve: Curves.easeInOut);
//     }
//   }

//   @override
//   onPageChanged(int index) {
//     currentPage = index;
//     update();
//   }

//   @override
//   void onInit() {
//     pageController = PageController();
//     super.onInit();
//   }
// }
