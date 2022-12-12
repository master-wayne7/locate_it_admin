// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, duplicate_ignore

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/map_controller.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final _googleMapController = Get.put(MapController());
  LatLng? currentPosition;

  Future getCurrentPosition() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied ||
        permission == geo.LocationPermission.deniedForever) {
      // ignore: unused_local_variable
      geo.LocationPermission asked = await geo.Geolocator.requestPermission();
    } else {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.best);
      setState(() {
        // ignore: unnecessary_null_comparison
        if (position != null) {
          currentPosition = LatLng(position.latitude, position.longitude);
        } else {}
      });

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 18);
      _googleMapController.moveToCurrentLocation(
          CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  Size screenSize() {
    return MediaQuery.of(context).size;
  }

  MapType type = MapType.normal;
  bool traffic = false;

  @override
  void initState() {
    getCurrentPosition();

    polylinePoints = PolylinePoints();
    super.initState();
  }

  int count = 0;

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDkj5oFjAVLELUaeVZgJ17XwTFNjPduon4";
  Set<Polyline> polylines = <Polyline>{};
  List<Map> firePoints = [];
  List<LatLng> polylineCoordinates = [];
  List<Color> polyColors = [
    const Color.fromARGB(255, 163, 33, 243),
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.black,
  ];

  onRepeat() async {
    Timer(const Duration(seconds: 2), await createPolyLine());
  }

  createPolyLine() async {
    await FirebaseFirestore.instance
        .collection('routes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        firePoints.add(doc["polypoints"]);
        // print('-------------------MAP-----------------------');
      }
    });
    // print(firePoints);
    // print('-----------------------firepoints---------------------------');
    for (var point in firePoints) {
      // point = {};d
      for (var i = 0; i < point.length - 1; i++) {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPiKey,
          PointLatLng(point[i.toString()][0], point[i.toString()][1]),
          PointLatLng(
              point[(i + 1).toString()][0], point[(i + 1).toString()][1]),
          travelMode: TravelMode.driving,
        );

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            // print(polylineCoordinates);
          }
          polylines.add(Polyline(
            polylineId: PolylineId('poly$count'),
            color: polyColors[count],
            points: polylineCoordinates,
            width: 7,
          ));
          // finalPoly;
          // print(polylineCoordinates.last.latitude.toString().substring(0, 6) +
          //     '========================' +
          //     polylineCoordinates.last.longitude.toString().substring(0, 6));
          // print(point[(point.length - 1).toString()][0]
          //         .toString()
          //         .substring(0, 6) +
          //     '\\\\\\\\\\\\\\\\\\\\\\\\' +
          //     point[(point.length - 1).toString()][1]
          //         .toString()
          //         .substring(0, 6));

          // setState(() {
          // print(polylineCoordinates);

          // count++;
        } else {}
        // result = null;
        // print(point[(i - 1).toString()]);
      }
      count++;
      if (count == 6) {
        count = 0;
      }

      // // });
      // if (polylineCoordinates.last.latitude.toString().substring(0, 6) ==
      //         point[(point.length - 1).toString()][0]
      //             .toString()
      //             .substring(0, 6) &&
      //     polylineCoordinates.last.longitude.toString().substring(0, 6) ==
      //         point[(point.length - 1).toString()][1]
      //             .toString()
      //             .substring(0, 6)) {
      polylineCoordinates = [];
      // polylineCoordinates.add();
      // continue;
      // }

      // print(point.toString() + '-----------------------------');
    }
    setState(() {});

    // print(polylines.);
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Stack(alignment: Alignment.center, children: [
        GetBuilder<MapController>(builder: (_) {
          return Obx(() {
            return GoogleMap(
                trafficEnabled: traffic,
                mapToolbarEnabled: true,
                compassEnabled: true,
                mapType: type,
                initialCameraPosition:
                    CameraPosition(target: currentPosition!, zoom: 17),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                polylines: polylines,
                markers: _googleMapController.markers!.toSet(),
                zoomGesturesEnabled: true,
                onTap: (argument) {
                  _googleMapController.moveToCurrentLocation(argument);
                },
                onMapCreated: (controller) {
                  _googleMapController.setGoogleMapController(controller);
                  Timer(const Duration(seconds: 2), onRepeat());
                });
          });
        }),
        Obx(() {
          return Column(
            children: [
              Visibility(
                visible: _googleMapController.buttonsVisibility.value,
                child: Container(
                  height: 50,
                  color: Colors.blue[200],
                  child: ListView.builder(
                      itemCount: _googleMapController.markers?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                _googleMapController.moveToCurrentLocation(
                                    _googleMapController
                                        .markers![index].position);
                              },
                              child: Column(
                                children: [
                                  Text(_googleMapController
                                      .markers![index].infoWindow.title
                                      .toString()),
                                  Text(
                                      "${_googleMapController.markers![index].infoWindow.snippet.toString()} km/h"),
                                ],
                              )),
                        );
                      }),
                ),
              ),
            ],
          );
        }),
        Positioned(
          top: 350,
          right: 4,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30)),
            child: SizedBox(
              height: screenSize().height * 0.05,
              width: screenSize().width * 0.11,
              child: SpeedDial(
                direction: SpeedDialDirection.up,
                elevation: 0,
                icon: Icons.layers_outlined,
                iconTheme: const IconThemeData(color: Colors.black, size: 35),
                backgroundColor: Colors.white,
                spacing: 10,
                overlayOpacity: 0,
                visible: true,
                tooltip: "Layers",
                children: [
                  SpeedDialChild(
                    label: 'Default',
                    elevation: 10,
                    onTap: () async {
                      setState(() {
                        type = MapType.normal;
                      });
                      Fluttertoast.showToast(msg: "Default view enabled");
                    },
                  ),
                  SpeedDialChild(
                      label: 'Satelite',
                      elevation: 10,
                      onTap: () {
                        setState(() {
                          type = MapType.hybrid;
                        });
                        Fluttertoast.showToast(msg: "Satelite view enabled");
                      }),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 400,
          right: 4,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30)),
            child: SizedBox(
              height: screenSize().height * 0.05,
              width: screenSize().width * 0.11,
              child: SpeedDial(
                direction: SpeedDialDirection.down,
                elevation: 0,
                icon: Icons.traffic_outlined,
                iconTheme: const IconThemeData(color: Colors.black, size: 35),
                backgroundColor: Colors.white,
                spacing: 1,
                overlayOpacity: 0,
                visible: true,
                tooltip: "Traffic",
                spaceBetweenChildren: 1,
                children: [
                  SpeedDialChild(
                    label: 'Enable',
                    elevation: 10,
                    onTap: () async {
                      setState(() {
                        traffic = true;
                      });
                      Fluttertoast.showToast(msg: "Traffic enabled");
                    },
                  ),
                  SpeedDialChild(
                      label: 'Disable',
                      elevation: 10,
                      onTap: () {
                        setState(() {
                          traffic = false;
                        });
                        Fluttertoast.showToast(msg: "Traffic disabled");
                      }),
                ],
              ),
            ),
          ),
        ),
      ]);
    }
  }
}
