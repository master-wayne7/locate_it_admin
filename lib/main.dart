import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:locate_it_user_1/loading_screen.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:loginuicolors/screens/home_page.dart';
import 'package:loginuicolors/screens/notice.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../screens/loading_screen.dart';

// import 'package:locate_it_user_1/map2.dart';
// import 'package:locate_it_user_1/map2.dart';
String? finalEmail;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Locate It",
        themeMode: ThemeMode.system,
        home: const MyHomePage(),
        // home: const MapTwo(),
        theme:
            ThemeData(primaryColor: const Color.fromARGB(255, 158, 239, 255))),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getCurrentPosition() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied ||
        permission == geo.LocationPermission.deniedForever) {
      // ignore: unused_local_variable
      geo.LocationPermission asked = await geo.Geolocator.requestPermission();
    }
  }

  @override
  // void initState() {
  //   getCurrentPosition();
  //   super.initState();
  // }
  void initState() {
    getCurrentPosition();
    getValidationData().whenComplete(() async {
      Timer(
          const Duration(seconds: 3),
          (() => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) =>
                  finalEmail == null ? const HomePage() : const MyNotice())))));
    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail!;
    });

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyNotice()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("animation/location.json")),
    );
  }
}
