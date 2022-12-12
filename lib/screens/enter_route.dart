// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, unused_local_variable, body_might_complete_normally_nullable, invalid_return_type_for_catch_error, sized_box_for_whitespace

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../model/route_model.dart';

class EnterRoute extends StatefulWidget {
  const EnterRoute({Key? key}) : super(key: key);

  @override
  State<EnterRoute> createState() => _EnterRouteState();
}

class _EnterRouteState extends State<EnterRoute> {
  CollectionReference route = FirebaseFirestore.instance.collection('routes');
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late RouteModel routeModel = RouteModel(
    "",
    '',
    List<String>.empty(growable: true),
  );

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  List<TextEditingController> intermediateController = [];
  List<dynamic> _placesList = [];
  Map<String, List<double>> points = {};
  int count = 0;

  @override
  void initState() {
    super.initState();

    routeModel.intermediatePoint.add("");
    intermediateController.add(TextEditingController());
    intermediate.add(0);
  }

  void addEmailControl() {
    setState(() {
      routeModel.intermediatePoint.add("");
      intermediateController.add(TextEditingController());
      intermediate.add(0);
    });
  }

  void removeEmailControl(index) {
    setState(() {
      if (routeModel.intermediatePoint.length > 1) {
        routeModel.intermediatePoint.removeAt(index);
        intermediateController.removeAt(index);
        intermediate.removeAt(index);
      }
    });
  }

  void OnChange(TextEditingController controller) {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDkj5oFjAVLELUaeVZgJ17XwTFNjPduon4";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  int start = 0;
  int end = 0;
  List<int> intermediate = [];
  var uuid = const Uuid();
  String _sessionToken = '122344';

  Widget Suggestion(TextEditingController controller) {
    // return Container();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _placesList.isEmpty ? 1 : _placesList.length,
        itemBuilder: ((context, index) {
          // return Container();
          return _placesList.isEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      color: Colors.grey[400],
                    ),
                    ListTile(
                      title: Text(_placesList[index]['description']),
                      leading:
                          Icon(Icons.location_pin, color: Colors.grey[400]),
                      onTap: () {
                        setState(() {
                          controller.text = _placesList[index]['description'];
                          start = 0;
                          end = 0;
                          for (var i = 0; i < intermediate.length; i++) {
                            intermediate[i] = 0;
                          }
                        });
                      },
                    )
                  ],
                );
        }));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            title: const Text(
              "Enter a New Route",
              style: TextStyle(color: Colors.black),
            )),
        body: ListView(
          children: [
            Column(
              children: [
                Form(
                  key: globalFormKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19)),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: startController,
                                      onTap: (() {
                                        setState(() {
                                          _placesList = [];
                                          start = 1;
                                          end = 0;
                                          for (var i = 0;
                                              i < intermediate.length;
                                              i++) {
                                            intermediate[i] = 0;
                                          }
                                        });
                                      }),
                                      onChanged: ((a) =>
                                          OnChange(startController)),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "  Please Enter A Starting Point";
                                        }
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onSaved: (onSavedVal) => {
                                        routeModel.startingPoint = onSavedVal!,
                                      },
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromARGB(255, 214, 214, 214),
                                        filled: true,
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
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(19.0)),
                                        ),
                                        hintText: "Starting Point",
                                      ),
                                    ),
                                    start == 1
                                        ? Suggestion(startController)
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          intermediatePointContainerUI(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19)),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onTap: (() {
                                        setState(() {
                                          _placesList = [];
                                          start = 0;
                                          end = 1;
                                          for (var i = 0;
                                              i < intermediate.length;
                                              i++) {
                                            intermediate[i] = 0;
                                          }
                                        });
                                      }),
                                      controller: endController,
                                      onChanged: ((a) =>
                                          OnChange(endController)),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "  Please Enter A Ending Point";
                                        }
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onSaved: (onSavedVal) => {
                                        routeModel.endingPoint = onSavedVal!,
                                      },
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromARGB(255, 214, 214, 214),
                                        filled: true,
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
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(19.0)),
                                        ),
                                        hintText: "Ending Point",
                                      ),
                                    ),
                                    end == 1
                                        ? Suggestion(endController)
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: RawMaterialButton(
                                    fillColor: const Color.fromARGB(
                                        255, 100, 255, 105),
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    splashColor:
                                        const Color.fromARGB(255, 69, 161, 72),
                                    onPressed: () async {
                                      if (validateAndSave()) {
                                        List<Location> locations =
                                            await locationFromAddress(
                                                startController.toString());
                                        points['$count'] = [
                                          locations.last.latitude,
                                          locations.last.longitude
                                        ];
                                        count++;
                                        List<Location> intermediateLoc = [];
                                        for (var i = 0;
                                            i < intermediateController.length;
                                            i++, count++) {
                                          intermediateLoc =
                                              await locationFromAddress(
                                                  intermediateController[i]
                                                      .toString());
                                          points['$count'] = [
                                            intermediateLoc.last.latitude,
                                            intermediateLoc.last.longitude
                                          ];
                                        }
                                        List<Location> locationsFinal =
                                            await locationFromAddress(
                                                endController.toString());
                                        points['$count'] = [
                                          locationsFinal.last.latitude,
                                          locationsFinal.last.longitude
                                        ];
                                        route.add({
                                          'startingPoint':
                                              routeModel.startingPoint,
                                          'endingPoint': routeModel.endingPoint,
                                          'intermediatePoint':
                                              routeModel.intermediatePoint,
                                          'polypoints': points
                                        }).then((value) {
                                          Fluttertoast.showToast(
                                              msg: 'Route Added');
                                          Navigator.pop(context);
                                        }).catchError((e) =>
                                            Fluttertoast.showToast(
                                                msg: e.toString()));
                                      }
                                    },
                                    child: const Text(
                                      "Add Route",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget intermediatePointContainerUI() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: routeModel.intermediatePoint.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: emailUI(index),
              ),
            ]),
          ],
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget emailUI(index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(19)),
                    child: Column(
                      children: [
                        TextFormField(
                          onTap: () {
                            setState(() {
                              _placesList = [];
                              start = 0;
                              end = 0;
                              intermediate[index] = 1;
                              for (var i = 0; i < intermediate.length; i++) {
                                if (i == index) {
                                  continue;
                                }
                                intermediate[i] = 0;
                              }
                            });
                          },
                          controller: intermediateController[index],
                          onChanged: ((a) =>
                              OnChange(intermediateController[index])),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "  Please Enter A Intermidiate Point";
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (onSavedVal) => {
                            routeModel.intermediatePoint[index] = onSavedVal!,
                          },
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 214, 214, 214),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(19.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(19.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(19.0)),
                            ),
                            hintText: "Intermediate Point",
                          ),
                        ),
                        intermediate[index] == 1
                            ? Suggestion(intermediateController[index])
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: index == routeModel.intermediatePoint.length - 1,
                child: SizedBox(
                  width: 35,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      addEmailControl();
                    },
                  ),
                ),
              ),
              Visibility(
                visible: index > 0,
                child: SizedBox(
                  width: 35,
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      removeEmailControl(index);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
