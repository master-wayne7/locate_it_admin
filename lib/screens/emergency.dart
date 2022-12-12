import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  CollectionReference emergencynumber =
      FirebaseFirestore.instance.collection('emergency_number');
  TextEditingController namecontroller = TextEditingController();
  TextEditingController numbercontroller = TextEditingController();

  final _namekey = GlobalKey<FormState>();
  final _numberkey = GlobalKey<FormState>();
  deleteContact(id) {
    FirebaseFirestore.instance
        .collection('emergency_number')
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Contact Deleted'))
        .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: const Text(
            'Emergency Contacts',
            style: TextStyle(color: Colors.black),
          )),
      body: RawScrollbar(
          child: Container(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
        child: StreamBuilder(
          stream: emergencynumber.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Number ${index + 1}',
                                      //   style: const TextStyle(fontSize: 18),
                                      // ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "${snapshot.data!.docs[index]['name']}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Phone no : ${snapshot.data!.docs[index]['number']}",
                                              style: const TextStyle(
                                                  fontSize: 17)),
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
                                    ]),
                                IconButton(
                                    onPressed: () async {
                                      return showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Delete Contact Details'),
                                              content: const Text(
                                                  "Do you really want to delete this contact"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('No')),
                                                TextButton(
                                                    onPressed: () async {
                                                      await deleteContact(
                                                          snapshot.data
                                                              .docs[index].id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Yes')),
                                              ],
                                            );
                                          }));
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          return showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: const Text('Add Contact'),
                  content: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter Name'),
                      Form(
                        key: _namekey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: namecontroller,
                          onSaved: (newValue) {
                            namecontroller.text = newValue!;
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
                      const Text('Enter the Contact Number'),
                      Form(
                          key: _numberkey,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: numbercontroller,
                            keyboardType: TextInputType.phone,
                            onSaved: (newValue) {
                              numbercontroller.text = newValue!;
                            },
                            decoration: const InputDecoration(
                                hintText: "Enter the phone number here"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter The Phone Numer";
                              }
                              return null;
                            },
                          )),
                    ],
                  )),
                  actions: [
                    TextButton(
                        onPressed: () {
                          namecontroller.clear();
                          numbercontroller.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancle')),
                    TextButton(
                        onPressed: () {
                          if (_namekey.currentState!.validate() &&
                              _numberkey.currentState!.validate()) {
                            emergencynumber.add({
                              'name': namecontroller.text,
                              'number': numbercontroller.text
                            }).then((value) {
                              Fluttertoast.showToast(
                                  msg: 'Emergency Contact Added');
                              namecontroller.clear();
                              numbercontroller.clear();
                              Navigator.of(context).pop();
                            }).catchError((e) =>
                                Fluttertoast.showToast(msg: e.toString()));
                          }
                        },
                        child: const Text('Save')),
                  ],
                );
              }));
        },
      ),
    );
  }
}
