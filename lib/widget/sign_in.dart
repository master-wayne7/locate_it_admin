// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/notice.dart';
// import 'package:locate_it_user_1/forget_password.dart';
// import 'package:locate_it_user_1/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/forget_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Size screenSize() {
    return MediaQuery.of(context).size;
  }

  int valid = 1;
  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(msg: "Login Succesful");
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
    if (user == null) {
      valid = 0;
    }
    return user;
  }

  final TextEditingController _emailController = TextEditingController();
  // ignore: no_leading_underscores_for_local_identifiers
  final TextEditingController _passwordController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  bool obscure = true;

  @override
  void initState() {
    _passwordController.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  Future<bool> admin() async {
    var doc = await FirebaseFirestore.instance
        .collection('admin')
        .doc("uv7LaHpn2uYKPyRMEuKN")
        .get();
    final data = doc.data() as Map<String, dynamic>;
    print(data);
    if (data["email"] == _emailController.text) {
      // print("objec2111111111111111111111111111111111111111111111111t");
      return true;
    }
    return false;
  }

// doc.get().then(
//   (DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     // ...
//   },
//   onError: (e) => print("Error getting document: $e"),
// );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize().height * 0.03,
            ),
            const Text(
              'Enter Your Log-in Credentials',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 10,
              child: Form(
                key: _emailKey,
                child: TextFormField(
                  autofillHints: const [AutofillHints.email],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "  Please Enter Your Email";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_,-]+@[a-zA-Z0-9,-]+.[a-z]")
                        .hasMatch(value)) {
                      return "  Please enter a valid Email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _emailController.text = value!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Color.fromARGB(255, 219, 219, 219),
                    hintText: "E-Mail address",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 10,
              child: Form(
                key: _passwordKey,
                child: TextFormField(
                  autofillHints: const [AutofillHints.password],
                  onSaved: (value) {
                    _passwordController.text = value!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "  Password is required for Sign In!!";
                    }
                    if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                      return "  Enter a valid Password(Min 8 characters)";
                    }
                    return null;
                  }),
                  controller: _passwordController,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    suffixIcon: _passwordController.text.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : IconButton(
                            onPressed: (() {
                              setState(() {
                                obscure = obscure == true ? false : true;
                              });
                            }),
                            icon: Icon(
                                obscure == true
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.grey)),
                    suffixIconColor: Colors.grey,
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 219, 219, 219),
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Colors.grey,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(19.0)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgetPassword()));
                  },
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     setState(() {});
                //   },
                //   child: Text(
                //     "Create an Account",
                //     style: TextStyle(
                //         color: Colors.blue, decoration: TextDecoration.underline),
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              child: RawMaterialButton(
                onPressed: (() async {
                  // admin();

                  if (_emailKey.currentState!.validate()) {
                    if (_passwordKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data.')));
                    }
                    if (await admin()) {
                      User? user = await loginUsingEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          'email', _emailController.text);
                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => const MyNotice())));
                      } else {
                        valid = 0;
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Invalid Account');
                    }
                  }
                }),
                elevation: 10,
                fillColor: const Color.fromARGB(255, 1, 172, 69),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SizedBox(
                  height: screenSize().height * 0.06,
                  child: const Center(
                      child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
