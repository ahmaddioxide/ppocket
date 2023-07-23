// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class InputField extends StatelessWidget {
//   final String text;
//   final IconData postfixIcon;
//   final bool obscureText;
//   final ValueChanged<String>? onChanged;
//   final FormFieldValidator<String>? validator;
//
//   const InputField({
//     Key? key,
//     required this.text,
//     required this.postfixIcon,
//     this.obscureText = false,
//     this.onChanged,
//     this.validator,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           text,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16.0,
//           ),
//         ),
//
//         SizedBox(
//           height: Get.height * .06, // Set the height to 30 pixels
//           child: TextFormField(
//             obscureText: obscureText,
//             onChanged: onChanged,
//             validator: validator,
//             decoration: InputDecoration(
//               suffixIcon: Icon(
//                 postfixIcon,
//                 size: 25,
//               ),
//               border: const OutlineInputBorder(),
//             ),
//           ),
//         ),
//         // Adjust the spacing as needed
//       ],
//     );
//   }
// }
