// import 'dart:ffi';

// ignore_for_file: unused_local_variable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/database.dart';
// import 'package:locate_it_user_1/database.dart';
// import 'package:location/location.dart';
// import 'package:location_tracker/services/database.dart';

class MapController extends GetxController {
  late GoogleMapController googleMapController;
  RxList<Marker>? markers = RxList<Marker>();
  String googleAPiKey = "AIzaSyDkj5oFjAVLELUaeVZgJ17XwTFNjPduon4";
  RxDouble currentLat = 24.5942497.obs;
  RxDouble currentLng = 73.7648697.obs;
  final ref = FirebaseDatabase.instance.ref('BUS');
  RxBool buttonsVisibility = false.obs;
  Position? currentLocation;

  getCurrentPosition() async {
    var currentLocation = await Geolocator.getCurrentPosition();
    return currentLocation;
  }

  @override
  void onReady() async {
    await Future.delayed(const Duration(seconds: 5));
    calculateSpeed();
    super.onReady();
  }

  void setGoogleMapController(GoogleMapController controller) async {
    googleMapController = controller;

    // await getCurrentPosition();
    // await moveToCurrentLocation(LatLng(currentLat.value, currentLng.value));
    await getAllMarkers();
  }

  moveToCurrentLocation(currentPosition) async {
    await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 15,
        target: currentPosition,
      ),
    ));
  }

  getAllMarkers() {
    markers!.clear();
    DatabaseServices().fatchDatabase();
  }

  updateCustomIcon() {
    return BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/icon/bus.png');
  }

  calculateSpeed() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
        PointLatLng(currentLat.value, currentLng.value));
  }
}
