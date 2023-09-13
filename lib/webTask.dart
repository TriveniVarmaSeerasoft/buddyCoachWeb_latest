import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class webTask extends StatefulWidget {
  const webTask({super.key});

  @override
  State<webTask> createState() => _taskState();
}

class _taskState extends State<webTask> {
  TextEditingController _notesController = TextEditingController();
  TextEditingController _uploadCodeController = TextEditingController();
  TextEditingController _workingAreaController = TextEditingController();

  var higherEducation = [".pdf", ".jpeg", ".jpg", "pdf"];
  String? dropdownValue = "Select File type";
  @override
  void initState() {
    GetuserAssignments();
    super.initState();
    dropdownValue = higherEducation[1];
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var getTokenFrmCoursesScreen = Get.arguments;

  Map? mapresponse;
  List? listresponse;
  GetuserAssignments() async {
    print("api starts here");
    print('details:${getTokenFrmCoursesScreen[1]}');
    print("${getTokenFrmCoursesScreen[0]}");
    print('details:${getTokenFrmCoursesScreen[1]}');
    // await Databasehelper.instance.
    http.Response response = await http.get(
      Uri.parse(
          "https://f16f-183-83-175-90.ngrok-free.app/conceptsToCoursetoUser/${getTokenFrmCoursesScreen[1]}"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "${getTokenFrmCoursesScreen[0]}"
      },
    );
    print("response:${response.body}");
    if (response.statusCode == 200) {
      setState(() {});
      listresponse = json.decode(response.body);
      print(listresponse);
      print("successful");
    } else {
      print("unsuccessful");
    }
  }

  File? _file;

  void filePick() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles();
    setState(() {
      _file = File(file!.files.single.path!);
    });
    print("file selected to upload");
  }

  fileAttachmentApi() async {
    print("1");
    var stream = http.ByteStream(_file!.openRead());

    stream.cast();
    var length = await _file!.length();
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://f16f-183-83-175-90.ngrok-free.app/fileAttachmentCoordinatorConnect"));
    print("2");
    Map<String, String> headers = {
      "Accept": "/",
      "Content-Type": "application/json",
      "Authorization": "${getTokenFrmCoursesScreen[0]}"
    };
    String filename = _file!.path.split("/").last;
    request.files
        .add(await http.MultipartFile.fromPath('fileAttachment', filename));
    request.headers["Authorization"] = "${getTokenFrmCoursesScreen[0]}";
    print("3");
    var multipartFile = new http.MultipartFile("fileAttachment", stream, length,
        filename: filename);
    request.files.add(multipartFile);
    // request.headers["Authorization"] = "${token[0]['token']}";
    print("image is ready to upload");

    var response = await request.send();
    print("status code = ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Image Uploaded");
      var res = await http.Response.fromStream(response);
      var filepaths = json.decode(res.body);
      print("filepath is:$filepaths");

      PostAssignments(
          // getTokenFrmCoursesScreen[2],
          _workingAreaController.text,
          _notesController.text,
          _uploadCodeController.text,
          filepaths['message']);

      Get.defaultDialog(
          title: "image uploaded",
          content: Text("Response=$filepaths"),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Text("ok"),
            )
          ]);
    }
  }
  // .........................................................
  // ...........................................................

  PostAssignments(
      String workarea, String notes, String code, String fileattachment) async {
    print("before encoding");
    var data = json.encode({
      // "conceptID": conceptId,
      "workingArea": workarea.toString(),
      "notes": notes.toString(),
      "codeArea": code.toString(),
      // "workingArea": _workingAreaController.text,
      // "notes": _notesController.text,
      // "codeArea": _uploadCodeController.text,
      "fileAttachment": fileattachment
    });
    http.Response response = await http.put(
        Uri.parse(
            "https://f16f-183-83-175-90.ngrok-free.app/conceptAssignment/${getTokenFrmCoursesScreen[2]}"),
        headers: {
          "accept": "*/*",
          "Content-type": "application/json",
          "Authorization": "${getTokenFrmCoursesScreen[0]}"
        },
        body: data);
    if (response.statusCode == 200) {
      print("posting the values");
      print(response.statusCode);
      setState(() {
        mapresponse = json.decode(response.body);
      });
      print("Response: $mapresponse");
    } else {
      print("didn't post");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assignments",
        ),
        backgroundColor: Color(0xff1F7A8C),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.download)),
                                Text(
                                  "Assignments/Tasks :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: 300,
                                height: 400,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          width: 50,
                                          height: 100,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "\u2022",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ), //bullet text
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                //space between bullet and text
                                                Expanded(
                                                  child: Text(
                                                    "Assignment $index : ${listresponse![index]['tasks']}",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ), //text
                                                )
                                              ]));
                                    }),
                              ),
                            ),
                          ],
                        ),
                        // userAssignments(),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                          indent: 20,
                          endIndent: 0,
                          width: 20,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.document_scanner_rounded)),
                                Text(
                                  "Outcomes/Evaluation points:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.black),
                              //     borderRadius: BorderRadius.circular(20)),
                              width: 300,
                              height: 500,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  // listresponse?.length == null ? 0 : listresponse?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        width: 100,
                                        height: 100,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\u2022",
                                                style: TextStyle(fontSize: 20),
                                              ), //bullet text
                                              SizedBox(
                                                width: 10,
                                              ), //space between bullet and text
                                              Expanded(
                                                child: Text(
                                                  "outcome $index : ${listresponse![index]['outcomeOrEvaluationPoints']}",
                                                  // outcomeSubmission,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ), //text
                                              )
                                            ]));
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Working area:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _notesController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    maxLength: 1000,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        labelText: "Write something here",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff1F7A8C),
                            width: 2.0,
                          ),
                        )),
                  ),
                  Text(
                    "Solution:  Upload Code<optional>",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _uploadCodeController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    maxLength: 1000,
                    decoration: InputDecoration(
                        // hintText: 'Notes',
                        labelText: "Add code here",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff1F7A8C),
                            width: 2.0,
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Files here",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          alert();
                        },
                        child: Text(
                          "Add (+)",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff1F7A8C),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Center(
                    child: Container(
                      // height: height - 300,
                      // width: width - 400,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Text(
                            "File submission form",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 500,
                            // height: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "File Name : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Add file name here',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff1F7A8C),
                                            width: 2.0,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 500,
                            // height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "File Type : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                      value: dropdownValue,
                                      items: higherEducation.map(
                                        (item) {
                                          return DropdownMenuItem(
                                              onTap: () {
                                                setState(() {
                                                  dropdownValue = item;
                                                });
                                                print(
                                                    "selected value is $dropdownValue");
                                              },
                                              child: Text(item),
                                              value: item);
                                        },
                                      ).toList(),
                                      onChanged: (item) {
                                        setState() {
                                          dropdownValue = item as String;
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "File : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    color: Color(0xff2D3142),
                                    onPressed: () {
                                      // filePick();
                                      fileAttachmentApi();
                                      // result = FilePicker.platform.pickFiles();
                                    },
                                    child: Text(
                                      "Browse",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          // Container(
                          //   height: 40,
                          //   width: 50,
                          //   child: result == null
                          //       ? Text(
                          //           "Upload file here",
                          //           textAlign: TextAlign.center,
                          //         )
                          //       : Image.file(result!),
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          MaterialButton(
                            color: Color(0xff1F7A8C),
                            onPressed: () async {
                              fileAttachmentApi();
                              // files = result?.files
                              //     .map((file) => file.path)
                              //     .toList();
                              // if (files == null) return;
                              // fileAttachmentApi();
                            },
                            child: Text(
                              "Upload",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
