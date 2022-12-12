// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/sign_in.dart';
// import 'package:locate_it_user_1/sign_in.dart';
// import 'package:locate_it_user_1/sign_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  Future<FirebaseApp> _initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 158, 239, 255), Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const LoginScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.forward();
  }

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
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // ignore: avoid_print
        print("No use found for that email");
      }
    }
    if (user == null) {
      valid = 0;
    }
    return user;
  }

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 1:
      // return const Center(child: SignUp());
      default:
        return const Center(child: SignIn());
    }
  }

  // Widget tryAgain() {
  //   // setState(() {
  //   if (valid == 1) {
  //     return SizedBox(
  //       height: 20.0,
  //     );
  //   } else {
  //     return Column(
  //       children: const [
  //         SizedBox(
  //           height: 10.0,
  //         ),
  //         Text(
  //           'Invalid credentials. Try again.',
  //         ),
  //         SizedBox(
  //           height: 10.0,
  //         ),
  //       ],
  //     );
  //     // );
  //   }
  // }
  int _currentIndex = 0;
  int hasBeenPressed1 = 1;
  int hasBeenPressed2 = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SizedBox(
          // margin: EdgeInsets.only(bottom: 200),
          height: screenSize().height * 0.9,
          // width: screenSize().width,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, top: 4),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenSize().height * .13,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            bottom: 10, left: screenSize().width * 0.05),
                        height: screenSize().height * 0.08,
                        child:
                            const Image(image: AssetImage('assets/icon.png'))),
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
                      height: (screenSize().height * 0.01),
                    ),
                    Center(
                      child: FadeTransition(
                        opacity: _animation,
                        child: Card(
                          elevation: 30,
                          shadowColor: const Color.fromARGB(255, 82, 82, 82),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: SizedBox(
                            height: (screenSize().height * 0.5),
                            width: (screenSize().width * 0.9),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Row(
                                //   children: [
                                //     SizedBox(
                                //       height: (screenSize().height * 0.07),
                                //       width: (screenSize().width * 0.45),
                                //       child: RawMaterialButton(
                                //         elevation: 0,
                                //         focusColor: Colors.white,
                                //         fillColor: hasBeenPressed1 == 1
                                //             ? Colors.white
                                //             : const Color.fromARGB(
                                //                 255, 217, 217, 217),
                                //         enableFeedback: true,
                                //         shape: const RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(25))),
                                //         onPressed: (() {
                                //           setState(() {
                                //             _currentIndex = 0;
                                //             hasBeenPressed1 = 1;
                                //             hasBeenPressed2 = 0;
                                //           });
                                //         }),
                                //         child: const Text(
                                //           'Sign In',
                                //           style: TextStyle(fontSize: 20),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       height: (screenSize().height * 0.07),
                                //       width: (screenSize().width * 0.45),
                                //       child: RawMaterialButton(
                                //         elevation: 0,
                                //         focusColor: Colors.white,
                                //         fillColor: hasBeenPressed2 == 1
                                //             ? Colors.white
                                //             : const Color.fromARGB(
                                //                 255, 217, 217, 217),
                                //         shape: const RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.only(
                                //                 topRight: Radius.circular(25))),
                                //         onPressed: (() {
                                //           setState(() {
                                //             _currentIndex = 1;
                                //             hasBeenPressed1 = 0;
                                //             hasBeenPressed2 = 1;
                                //           });
                                //         }),
                                //         child: const Text(
                                //           'Sign Up',
                                //           style: TextStyle(fontSize: 20),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Expanded(child: callPage(_currentIndex)),
                              ],
                            ),
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
      ),
    );
  }
}
