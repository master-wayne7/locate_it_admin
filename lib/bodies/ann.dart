import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  CollectionReference message =
      FirebaseFirestore.instance.collection('notification');
  Future<void> sendNotification(String alert, String download) async {
    message
        .add({
          'message': alert,
          'link': download,
          'createdOn': FieldValue.serverTimestamp(),
        })
        .then((value) => Fluttertoast.showToast(msg: 'Notification Sent'))
        .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result == null) {
      return;
    }
    setState(() {
      pickedFile = result.files.first;
      _controller.text = pickedFile!.name;
    });
  }

  Future openFile({required String url, String? fileName}) async {
    var name = fileName ?? url.split('/').last;
    var file = await downloadFile(url, name);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    var appStorage = await getApplicationDocumentsDirectory();
    var file = File('${appStorage.path}/$name');
    try {
      var response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var r;

  final TextEditingController _controller = TextEditingController();
  final notificationKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 232, 232, 232)),
          child: RawScrollbar(
            controller: _scrollController,
            radius: const Radius.circular(25.0),
            thickness: 7,
            thumbColor: const Color.fromARGB(255, 177, 177, 177),
            // thumbVisibility: true,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("notification")
                  .orderBy('createdOn', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17)),
                            elevation: 2,
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10, right: 15, bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Admin:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '''${snapshot.data!.docs[index]['message']}''',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  snapshot.data!.docs[index]['link'] == ''
                                      ? const SizedBox()
                                      : TextButton(
                                          onPressed: (() {
                                            openFile(
                                                url: snapshot.data!.docs[index]
                                                    ['link'],
                                                fileName: snapshot.data!
                                                    .docs[index]['message']);
                                          }),
                                          child: const Text("Tap to download")),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      snapshot.data!.docs[index]['createdOn'] ==
                                              null
                                          ? Text(
                                              '''${DateTime.now().day}/${DateTime.now().month}   ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString().padLeft(2, '0')}''')
                                          : Text(
                                              '''${snapshot.data!.docs[index]['createdOn'].toDate().day}/${snapshot.data!.docs[index]['createdOn'].toDate().month}   ${snapshot.data!.docs[index]['createdOn'].toDate().hour.toString()}:${snapshot.data!.docs[index]['createdOn'].toDate().minute.toString().padLeft(2, '0')}''',
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Row(children: [
              IconButton(
                  onPressed: (() {
                    selectFile();
                  }),
                  icon: const Icon(
                    Icons.attach_file,
                  )),
              Expanded(
                  child: Form(
                key: notificationKey,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (newValue) {
                    _controller.text = newValue!;
                  },
                  controller: _controller,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.keyboard),
                    hintText: "Send a message...",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              )),
              const SizedBox(
                width: 0,
              ),
              RawMaterialButton(
                onPressed: (() async {
                  if (_controller.text.isNotEmpty) {
                    var msg = _controller.text;
                    if (pickedFile != null) {
                      final path = 'files/${pickedFile!.name}';
                      final file = File(pickedFile!.path!);
                      var ref = FirebaseStorage.instance.ref().child(path);
                      ref.putFile(file).then((value) async {
                        r = await ref.getDownloadURL();
                        if (r.isNotEmpty) {
                          await sendNotification(msg, r);
                        }
                      });
                      pickedFile = null;
                    } else {
                      sendNotification(msg, '');
                    }
                    _controller.clear();
                  } else {
                    Fluttertoast.showToast(
                        msg: '''Please enter text before sending''');
                  }
                }),
                shape: const CircleBorder(side: BorderSide.none),
                fillColor: Colors.blue,
                highlightColor: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
