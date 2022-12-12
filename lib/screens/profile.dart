// ignore_for_file: unnecessary_string_interpolations, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginuicolors/model/admin_model.dart';
// import 'package:locate_it_user_1/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import 'home_page.dart';
// import 'model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  AdminModel loggedInUser = AdminModel();
  String name = '-';
  String email = '-';

  @override
  void initState() {
    // ignore: todo
    // // TODO: implement initState
    FirebaseFirestore.instance
        .collection("admin")
        .doc('uv7LaHpn2uYKPyRMEuKN')
        .get()
        .then((value) {
      loggedInUser = AdminModel.fromMap(value.data());
      setState(() {
        name = loggedInUser.name.toString();
        email = loggedInUser.email.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: 80,
                color: Colors.grey[600],
              ),
              const Text(
                'NAME',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '''$name''',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  // fontFamily: 'NewFont',
                  // letterSpacing: 1.0,
                ),
              ),
              Divider(
                height: 80,
                color: Colors.grey[600],
              ),
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    'E-Mail',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '''$email''',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  // fontFamily: 'NewFont',
                  letterSpacing: 0,
                ),
              ),
              Divider(
                height: 80,
                color: Colors.grey[600],
              ),
              RawMaterialButton(
                elevation: 10,
                enableFeedback: true,
                fillColor: const Color.fromARGB(255, 15, 231, 37),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('email');
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: ((context) => const HomePage())));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
