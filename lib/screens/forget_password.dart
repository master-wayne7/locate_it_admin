import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  Size screenSize() {
    return MediaQuery.of(context).size;
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      Fluttertoast.showToast(msg: 'Password reset E-mail sent');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 158, 239, 255), Colors.white],
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Reset your password'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: Colors.transparent,
              body: Center(
                child: SizedBox(
                  // margin: EdgeInsets.only(bottom: 200),
                  height: screenSize().height * 0.9,
                  // width: screenSize().width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: screenSize().width * 0.05),
                              height: screenSize().height * 0.13,
                              child: const Image(
                                  image: AssetImage('assets/icon.png'))),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.stretch,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         SizedBox(
                          //           width: screenSize().width * 0.56,
                          //         ),
                          //         Icon(
                          //           Icons.location_on,
                          //           color: Colors.red,
                          //           size: screenSize().height * 0.06,
                          //         )
                          //       ],
                          //     ),
                          //     const SizedBox(
                          //       height: 0,
                          //     ),
                          //     Container(
                          //       height: 50,
                          //       child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           const SizedBox(
                          //             width: 20,
                          //           ),
                          //           const Text(
                          //             'LOC',
                          //             style: TextStyle(
                          //               letterSpacing: 0.0,
                          //               fontSize: 50,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           Column(
                          //             children: [
                          //               SizedBox(
                          //                 height: screenSize().height * 0.013,
                          //               ),
                          //               Image.asset("assets/nav.png",
                          //                   height: screenSize().height * 0.05,
                          //                   width: screenSize().width * 0.09),
                          //             ],
                          //           ),
                          //           const Text(
                          //             "TE IT",
                          //             style: TextStyle(
                          //               fontSize: 50,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                          SizedBox(
                            height: (screenSize().height * 0.05),
                          ),
                          Card(
                            elevation: 30,
                            shadowColor: const Color.fromARGB(255, 82, 82, 82),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: SizedBox(
                              height: (screenSize().height * 0.44),
                              width: (screenSize().width * 0.9),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '''Recieve an Email to reset your password''',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    const Text(
                                        '''Submit your email address here to reset your password. Follow the link provided in the mail and create a new password for your account. Don't forget to check the spam folder.'''),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      elevation: 10,
                                      child: Form(
                                        key: _emailKey,
                                        child: TextFormField(
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "  Please Enter Your Email";
                                            }
                                            if (!RegExp(
                                                    "^[a-zA-Z0-9+_,-]+@[a-zA-Z0-9,-]+.[a-z]")
                                                .hasMatch(value)) {
                                              return "  Please enter a valid Email";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _emailController.text = value!;
                                          },
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            prefixIconColor: Colors.grey,
                                            filled: true,
                                            fillColor: Color.fromARGB(
                                                255, 219, 219, 219),
                                            hintText: "E-Mail address",
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.grey,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(19.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(19.0)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(19.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 20.0, 8, 8),
                                      child: RawMaterialButton(
                                        onPressed: (() async {
                                          if (_emailKey.currentState!
                                              .validate()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Processing Data.')));
                                            resetPassword();
                                            // ignore: use_build_context_synchronously

                                          }
                                        }),
                                        elevation: 10,
                                        fillColor: const Color.fromARGB(
                                            255, 1, 172, 69),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: SizedBox(
                                          height: screenSize().height * 0.06,
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              // SizedBox(
                                              //   width: 50,
                                              // ),
                                              Icon(Icons.mail_outline_sharp,
                                                  size: 20),
                                              Text(
                                                "Reset Password",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
