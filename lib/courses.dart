import 'dart:convert';
import 'packages/buddycoachweb_latest/courses.dart';
import 'package:buddycoachweb_latest/webTask.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class cousesDisplay extends StatefulWidget {
  const cousesDisplay({super.key});

  @override
  State<cousesDisplay> createState() => _cousesDisplayState();
}

class _cousesDisplayState extends State<cousesDisplay> {
  var getTokenFromLoginScreen = Get.arguments;
  Map? mapresponse;
  @override
  void initState() {
    super.initState();
    getCourses();
  }

  List? listresponse, listresponse1;
  getCourses() async {
    http.Response response = await http.get(
      Uri.parse("https://f16f-183-83-175-90.ngrok-free.app/learningsToUser"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "$getTokenFromLoginScreen"
      },
    );
    print(getTokenFromLoginScreen);
    print("sent the token and checking for response");
    // print(response.body);
    if (response.statusCode == 200) {
      // print
      print('successful');
      setState(() {
        listresponse = json.decode(response.body);
      });
      print(listresponse);
      print("${listresponse![0]['courseID']}");
    } else {
      print('fetch unsuccessful');
    }
  }

  getConcepts() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://f16f-183-83-175-90.ngrok-free.app/conceptsToCoursetoUser/${listresponse![0]['courseID']}"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "$getTokenFromLoginScreen"
      },
    );
    print("response:${response.body}");
    if (response.statusCode == 200) {
      setState(() {});
      listresponse1 = json.decode(response.body);
      print(listresponse1);
      print("successful");
    } else {
      print("unsuccessful");
    }
  }

  var conceptId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Courses"),
        ),
        body: Center(
          child: Column(children: [
            Text(
              "Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              width: 300,
              child: Card(
                child: Container(
                  height: 200,
                  width: 500,
                  child: ListView.builder(
                      itemCount: listresponse?.length == null
                          ? 0
                          : listresponse?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: '${listresponse![index]['courseID']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextSpan(
                                text:
                                    ' : ${listresponse![index]['courseName']}',
                              ),
                            ])),
                          ),
                        );
                      }),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                getConcepts();
              },
              child: Text("Get concepts for above courses"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Concepts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              width: 300,
              child: Card(
                child: Container(
                  height: 200,
                  width: 500,
                  child: ListView.builder(
                      itemCount: listresponse1?.length == null
                          ? 0
                          : listresponse1?.length,
                      itemBuilder: (context, index) {
                        conceptId = listresponse1![index]['courseID'];
                        return Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: '${listresponse1![index]['conceptID']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextSpan(
                                text:
                                    ' : ${listresponse1![index]['conceptName']}',
                              ),
                            ])),
                          ),
                        );
                      }),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                Get.to(() => webTask(),
                    transition: Transition.circularReveal,
                    arguments: [
                      getTokenFromLoginScreen,
                      listresponse![0]['courseID'],
                      conceptId
                    ]);
              },
              child: Text("Get Assignments"),
            ),
          ]),
        ));
  }
}
