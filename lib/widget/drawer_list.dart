// ignore_for_file: avoid_unnecessary_containers

import 'dart:io' show Platform, exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginuicolors/screens/drivers.dart';
import 'package:loginuicolors/screens/emergency.dart';
// import 'package:loginuicolors/profile.dart';

import '../screens/about_page.dart';
import '../screens/profile.dart';
// import 'about_page.dart';
// import 'package:locate_it_user_1/about_page.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({super.key});

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const ProfilePage())));
            }),
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              // ignore: prefer_const_constructors
              title: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'NewFont'
                ),
              ),
              // onTap: null,
            ),
          ),
          InkWell(
            // hoverColor: Colors.white,
            splashColor: Colors.grey[300],
            onTap: (() {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => const AboutPage())));
            }),
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              // ignore: prefer_const_constructors
              title: Text(
                'About',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'NewFont'
                ),
              ),
            ),
          ),
          InkWell(
            // hoverColor: Colors.white,
            splashColor: Colors.grey[300],
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const DriverList())));
            }),
            child: const ListTile(
              leading: Icon(
                Icons.co_present_rounded,
                color: Colors.black,
              ),
              // ignore: prefer_const_constructors
              title: Text(
                "Driver's info",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'NewFont'
                ),
              ),
            ),
          ),
          InkWell(
            // hoverColor: Colors.white,
            splashColor: Colors.grey[300],
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const EmergencyContact())));
            }),
            child: const ListTile(
              leading: Icon(
                Icons.contact_phone,
                color: Colors.black,
              ),
              // ignore: prefer_const_constructors
              title: Text(
                "Emergency Contacts",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'NewFont'
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (() {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            }),
            child: const ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.black,
              ),
              // ignore: prefer_const_constructors
              title: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'NewFont'
                ),
              ),
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
