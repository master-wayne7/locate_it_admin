import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  CollectionReference driver =
      FirebaseFirestore.instance.collection('driver_info');

  TextEditingController nameController = TextEditingController();
  TextEditingController phNoController = TextEditingController();
  TextEditingController busNoController = TextEditingController();

  final _nameKey = GlobalKey<FormState>();
  final _phNoKey = GlobalKey<FormState>();
  final _busNoKey = GlobalKey<FormState>();

  deleteDriver(id) {
    FirebaseFirestore.instance
        .collection('driver_info')
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Driver Details Deleted'))
        .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Driver\'s Information',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: const Color.fromARGB(255, 158, 239, 255),
      ),
      body: RawScrollbar(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
          child: StreamBuilder(
            stream: driver.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              return !snapshot.hasData
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) => Column(
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Driver ${index + 1}s Info',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "Name : ${snapshot.data!.docs[index]['name']}",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Phone no. : ${snapshot.data!.docs[index]['number']}",
                                                  style: const TextStyle(
                                                      fontSize: 15)),
                                              IconButton(
                                                  onPressed: () async {
                                                    await FlutterPhoneDirectCaller
                                                        .callNumber(
                                                            "${snapshot.data!.docs[index]['number']}");
                                                  },
                                                  icon: const Icon(
                                                    Icons.call,
                                                    size: 17,
                                                  ))
                                            ],
                                          ),
                                          Text(
                                            "Alloted Bus No. : ${snapshot.data!.docs[index]['alloted_bus_number']}",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            return showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete Driver Details'),
                                                    content: const Text(
                                                        "Do you really want to delete driver's info?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('No')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await deleteDriver(
                                                                snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                    ],
                                                  );
                                                }));
                                            // await deleteRoute(
                                            //     snapshot.data.docs[index].id);
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )));
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            return showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Text('Add Driver'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Enter the Driver Name'),
                          Form(
                            key: _nameKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: nameController,
                              onSaved: (newValue) {
                                nameController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter the name here"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter The Name";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text('Enter the Driver Phone Number'),
                          Form(
                            key: _phNoKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: phNoController,
                              keyboardType: TextInputType.phone,
                              onSaved: (newValue) {
                                phNoController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter the phone number here"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter The Phone Numer";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                              'Enter the Alloted bus number to the driver'),
                          Form(
                            key: _busNoKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: busNoController,
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) {
                                busNoController.text = newValue!;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter the bus number here"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter The bus Number";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            busNoController.clear();
                            nameController.clear();
                            phNoController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            if (_nameKey.currentState!.validate() &&
                                _phNoKey.currentState!.validate() &&
                                _busNoKey.currentState!.validate()) {
                              driver.add({
                                'alloted_bus_number': busNoController.text,
                                'name': nameController.text,
                                'number': phNoController.text
                              }).then((value) {
                                Fluttertoast.showToast(msg: 'Driver Added');
                                busNoController.clear();
                                nameController.clear();
                                phNoController.clear();
                                Navigator.of(context).pop();
                              }).catchError((e) =>
                                  Fluttertoast.showToast(msg: e.toString()));
                            }
                          },
                          child: const Text('Save')),
                    ],
                  );
                }));
          }),
    );
  }
}
