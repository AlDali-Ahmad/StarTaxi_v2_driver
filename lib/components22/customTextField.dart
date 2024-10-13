// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final Color hintColor;
//   final Color iconColor;
//   final IconData? iconData;
//   final double fontSize;
//   final IconButton? suffixIcon;
//   final bool? obscureText;

//   const CustomTextField({
//     required this.controller,
//     this.hintText = '',
//     this.hintColor = Colors.black26,
//     this.iconColor = Colors.black,
//     this.iconData,
//     this.fontSize = 17.0,
//     this.suffixIcon,
//     this.obscureText,
//     required TextAlign textAlign, required TextDirection textDirection,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
//         filled: true,
//         fillColor: Colors.blue.shade100,
//         border: InputBorder.none,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide.none,
//         ),
//         prefixIcon: Icon(
//           iconData,
//           color: iconColor,
//         ),
//         suffixIcon: suffixIcon,
//       ),
//     );
//   }
// }
