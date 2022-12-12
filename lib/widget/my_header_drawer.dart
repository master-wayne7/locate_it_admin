import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  Size screenSize() {
    return MediaQuery.of(context).size;
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
      width: double.infinity,
      height: screenSize().height * 0.35,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          height: screenSize().height * 0.25,
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // ignore: prefer_const_constructors
            image: DecorationImage(
              image: const AssetImage('assets/logo1.png'),
            ),
          ),
        ),
      ]),
    );
  }
}
