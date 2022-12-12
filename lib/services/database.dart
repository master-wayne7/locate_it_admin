import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/map_controller.dart';
// import 'package:locate_it_user_1/map_controller.dart';

class DatabaseServices {
  // final ref = FirebaseDatabase.instance.ref('BUS');
  // ignore: deprecated_member_use
  final ref = FirebaseDatabase(
          databaseURL:
              "https://locate-it-e063c-default-rtdb.asia-southeast1.firebasedatabase.app")
      // ignore: deprecated_member_use
      .ref("BUS");

  fatchDatabase() async {
    BitmapDescriptor markerIcon =
        await Get.find<MapController>().updateCustomIcon();
    ref.onValue.listen((DatabaseEvent event) {
      Get.find<MapController>().markers!.clear();
      final data = event.snapshot.value;

      String jsonString = jsonEncode(data);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      jsonData.forEach((key, value) {
        Marker marker = Marker(
            markerId: MarkerId(
              key,
            ),
            position: LatLng(value['Lat'].toDouble(), value['Lng'].toDouble()),
            icon: markerIcon,
            infoWindow: InfoWindow(title: key, snippet: '${value['SPEED']}'
                // "Lat:${value['Lat'].toDouble()}, Lng: ${value['Lng'].toDouble()}")
                ));
        Get.find<MapController>().markers?.add(marker);
        
      });
    });
  }

 
  
}
