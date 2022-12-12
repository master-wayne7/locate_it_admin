import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bodies/add_routes.dart';
import '../bodies/ann.dart';
import '../bodies/maps.dart';
import 'package:firebase_core/firebase_core.dart';

import '../controller/map_controller.dart';
import '../widget/drawer_list.dart';
import '../widget/my_header_drawer.dart';

class MyNotice extends StatefulWidget {
  const MyNotice({Key? key}) : super(key: key);

  @override
  State<MyNotice> createState() => _MyNoticeState();
}

int _currentIndex = 0;

class _MyNoticeState extends State<MyNotice> {
  // ignore: non_constant_identifier_names
  Widget callPage(Home) {
    switch (Home) {
      case 0:
        return const AddRoute();
      case 1:
        return const Announcement();
      case 2:
        return const Maps();

      default:
        return Container();
    }
  }

  Future<FirebaseApp> _initializeFirebaseApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _initializeFirebaseApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return callPage(_currentIndex);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Admin Panel',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  controller.buttonsVisibility.value == true
                      ? controller.buttonsVisibility.value = false
                      : controller.buttonsVisibility.value = true;
                },
                icon: const Icon(Icons.arrow_drop_down))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            // BottomNavigationBarItem(
            //   // backgroundColor: Color.fromARGB(255, 0, 255, 166),
            //   icon: Icon(Icons.home),
            //   label: 'Home',
            // ),
            BottomNavigationBarItem(
              //backgroundColor: Color.fromARGB(255, 0, 255, 166),
              icon: Icon(Icons.route),
              label: 'Route',
            ),
            BottomNavigationBarItem(
              // backgroundColor: Color.fromARGB(255, 0, 255, 166),
              icon: Icon(Icons.announcement_rounded),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
          ],
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: const Color.fromARGB(255, 254, 254, 255),
          backgroundColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: ((value) {
            setState(() {
              _currentIndex = value;
            });
          }),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: SingleChildScrollView(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const MyHeaderDrawer(),
                const SizedBox(height: 7.5),
                // ignore: prefer_const_constructors
                DrawerList(),
              ],
            ),
          ),
        ));
  }
}
