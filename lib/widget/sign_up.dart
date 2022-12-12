// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_auth/email_auth.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../screens/notice.dart';
// // import 'package:locate_it_user_1/main_screen.dart';
// // import 'package:locate_it_user_1/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../model/user_model.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   Size screenSize() {
//     return MediaQuery.of(context).size;
//   }

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   // ignore: no_leading_underscores_for_local_identifiers
//   final TextEditingController _passwordController = TextEditingController();
//   final _emailKey = GlobalKey<FormState>();
//   final _passwordKey = GlobalKey<FormState>();
//   final _nameKey = GlobalKey<FormState>();
//   final _otpKey = GlobalKey<FormState>();
//   int verified = 0;
//   EmailAuth emailAuth = EmailAuth(sessionName: "Locate IT");
//   Future<void> sendOTP() async {
//     // ignore: unused_local_variable
//     var res = await emailAuth.sendOtp(
//         recipientMail: _emailController.text, otpLength: 6);
//     if (res) {
//       Fluttertoast.showToast(msg: "OTP Sent");
//     } else {
//       Fluttertoast.showToast(msg: "OTP not Sent");
//     }
//   }

//   void verifyOTP() {
//     var res = emailAuth.validateOtp(
//         recipientMail: _emailController.text, userOtp: _otpController.text);
//     if (res) {
//       Fluttertoast.showToast(msg: "OTP Verified");
//       verified = 1;
//     } else {
//       verified = 0;
//       Fluttertoast.showToast(msg: "Invalid OTP");
//     }
//   }

//   bool obscure = true;

//   @override
//   void initState() {
//     _passwordController.addListener(onListen);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _passwordController.removeListener(onListen);
//     super.dispose();
//   }

//   void onListen() => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 18.0, right: 18.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // SizedBox(
//           //   height: screenSize().height * 0.03,
//           // ),
//           const Text(
//             'Create An Account',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(
//             height: 8.0,
//           ),
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//             elevation: 10,
//             child: Form(
//               key: _nameKey,
//               child: TextFormField(
//                 autofillHints: const [AutofillHints.name],
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return ("  Please Enter Your Name");
//                   }
//                   // if (!RegExp(
//                   //         "^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)")
//                   //     .hasMatch(value)) {
//                   //   return ("Please enter a valid Name");
//                   // }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _nameController.text = value!;
//                 },
//                 controller: _nameController,
//                 keyboardType: TextInputType.name,
//                 decoration: const InputDecoration(
//                   prefixIconColor: Colors.grey,
//                   filled: true,
//                   fillColor: Color.fromARGB(255, 219, 219, 219),
//                   hintText: "Name",
//                   prefixIcon: Icon(
//                     Icons.person,
//                     color: Colors.grey,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//             elevation: 10,
//             child: Form(
//               key: _emailKey,
//               child: TextFormField(
//                 autofillHints: const [AutofillHints.email],
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return ("  Please Enter Your Email");
//                   }
//                   if (!RegExp("^[a-zA-Z0-9+_,-]+@[a-zA-Z0-9,-]+.[a-z]")
//                       .hasMatch(value)) {
//                     return ("  Please enter a valid Email");
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _emailController.text = value!;
//                 },
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   prefixIconColor: Colors.grey,
//                   filled: true,
//                   fillColor: Color.fromARGB(255, 219, 219, 219),
//                   hintText: "E-Mail address",
//                   prefixIcon: Icon(
//                     Icons.email,
//                     color: Colors.grey,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//             elevation: 10,
//             child: Form(
//               key: _passwordKey,
//               child: TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 onSaved: (value) {
//                   _passwordController.text = value!;
//                 },
//                 validator: ((value) {
//                   if (value!.isEmpty) {
//                     return ("  Password is required for Sign Up!!");
//                   }
//                   if (!RegExp(r'^.{8,}$').hasMatch(value)) {
//                     return ("  Please enter a valid Password (Min 8 characters)");
//                   }
//                   return null;
//                 }),
//                 controller: _passwordController,
//                 obscureText: obscure,
//                 decoration: InputDecoration(
//                   suffixIcon: _passwordController.text.isEmpty
//                       ? Container(
//                           width: 0,
//                         )
//                       : IconButton(
//                           onPressed: (() {
//                             setState(() {
//                               obscure = obscure == true ? false : true;
//                             });
//                           }),
//                           icon: Icon(
//                               obscure == true
//                                   ? Icons.remove_red_eye_rounded
//                                   : Icons.remove_red_eye_outlined,
//                               color: Colors.grey)),
//                   suffixIconColor: Colors.grey,
//                   prefixIconColor: Colors.grey,
//                   filled: true,
//                   fillColor: const Color.fromARGB(255, 219, 219, 219),
//                   hintText: "Password",
//                   prefixIcon: const Icon(
//                     Icons.key,
//                     color: Colors.grey,
//                   ),
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   border: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//             elevation: 10,
//             child: Form(
//               key: _otpKey,
//               child: TextFormField(
//                 onSaved: (value) {
//                   _otpController.text = value!;
//                 },
//                 validator: ((value) {
//                   if (value!.isEmpty) {
//                     return ("  OTP is required for Verification!!");
//                   }
//                   // if (!RegExp(r'^.{8,}$').hasMatch(value)) {
//                   //   return ("  Please enter a valid Password (Min 8 characters)");
//                   // }
//                   return null;
//                 }),
//                 controller: _otpController,
//                 // obscureText: true,
//                 decoration: const InputDecoration(
//                   prefixIconColor: Colors.grey,
//                   filled: true,
//                   fillColor: Color.fromARGB(255, 219, 219, 219),
//                   hintText: "OTP",
//                   prefixIcon: Icon(
//                     Icons.onetwothree_sharp,
//                     color: Colors.grey,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.all(Radius.circular(19.0)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           TextButton(
//               onPressed: (() => sendOTP()),
//               child: const Text(
//                 'Send OTP',
//                 style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     color: Colors.blue,
//                     fontSize: 15),
//               )),

//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
//             child: RawMaterialButton(
//               elevation: 10,
//               fillColor: const Color.fromARGB(255, 1, 172, 69),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               onPressed: () async {
//                 verifyOTP();
//                 if (_emailKey.currentState!.validate() &&
//                     _passwordKey.currentState!.validate() &&
//                     _nameKey.currentState!.validate() &&
//                     _otpKey.currentState!.validate() &&
//                     verified == 1) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Processing Data.')));

//                   signUp(_emailController.text, _passwordController.text);
//                   final SharedPreferences sharedPreferences =
//                       await SharedPreferences.getInstance();
//                   sharedPreferences.setString('email', _emailController.text);
//                   Navigator.pushAndRemoveUntil(
//                       (context),
//                       MaterialPageRoute(
//                           builder: ((context) => const MyNotice())),
//                       (route) => false);
//                 }
//               },
//               child: SizedBox(
//                 height: screenSize().height * 0.06,
//                 child: const Center(
//                     child: Text(
//                   "Sign Up",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 )),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void signUp(String email, String password) async {
//     if (_emailKey.currentState!.validate() &&
//         _passwordKey.currentState!.validate() &&
//         _nameKey.currentState!.validate()) {
//       await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .then((value) => {postDetailsToFirestore()})
//           .catchError((e) {
//         Fluttertoast.showToast(msg: e!.message);
//       });
//     }
//   }

//   postDetailsToFirestore() async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;
//     UserModel userModel = UserModel();

//     userModel.email = user!.email;
//     userModel.uid = user.uid;
//     userModel.name = _nameController.text;

//     await firebaseFirestore
//         .collection("users")
//         .doc(user.uid)
//         .set(userModel.toMap());
//     Fluttertoast.showToast(msg: "Account Created Successfully");
//   }
// }
