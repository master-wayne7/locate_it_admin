// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/enter_route.dart';

class AddRoute extends StatefulWidget {
  const AddRoute({Key? key}) : super(key: key);

  @override
  State<AddRoute> createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  deleteRoute(id) {
    FirebaseFirestore.instance
        .collection('routes')
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Route Deleted'))
        .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  final ScrollController _scrollController = ScrollController();
  Size screenSize() => MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 10, left: screenSize().width * 0.03),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("routes").snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.docs.length == 0) {
                return const Center(
                    child: Text(
                  'Currently no routes are available.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ));
              } else {
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Card(
                                color: const Color.fromARGB(255, 210, 242, 249),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: const BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.black54)),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      width: screenSize().width * 0.786,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ExpansionTile(
                                                      expandedAlignment:
                                                          Alignment.topLeft,
                                                      title: Text(
                                                        "${snapshot.data.docs[index]['startingPoint']} - ${snapshot.data.docs[index]['endingPoint']}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "• ${snapshot.data!.docs[index]['startingPoint']}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: List.from(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'intermediatePoint']
                                                                  .map((points) =>
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(bottom: 6),
                                                                        child:
                                                                            Text(
                                                                          "• $points",
                                                                          style:
                                                                              const TextStyle(fontSize: 16),
                                                                        ),
                                                                      ))),
                                                            ),
                                                            Text(
                                                              "• ${snapshot.data!.docs[index]['endingPoint']}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      ]
                                                      // ],
                                                      )
                                                ])),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          return showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete Route'),
                                                  content: const Text(
                                                      "Do you really want to Delete Route?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('No')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          await deleteRoute(
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Yes')),
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
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    });
              }
            }),
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const EnterRoute())),
      ),
    );
  }
}
