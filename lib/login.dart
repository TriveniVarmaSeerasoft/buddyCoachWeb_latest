// ignore_for_file: prefer_if_null_operators, prefer_const_constructors

import 'dart:convert';
import 'package:buddycoachweb_latest/courses.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool securetext = true;
  bool visiblility = true;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  FocusNode passwordfocus = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  // final _storage = const FlutterSecureStorage();

// ................................
  Map? mapresponse;
  Future userLogin(String emailid, String password) async {
    var data = json.encode({
      "emailID": emailid,
      "password": password,
    });

    print("accessing api's");

    http.Response response = await http.post(
        Uri.parse("https://f16f-183-83-175-90.ngrok-free.app/login"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
        },
        body: data);
    print("API is accessed");
    print(response.body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      setState(() {
        mapresponse = json.decode(response.body);
      });
      Get.to(() => cousesDisplay(),
          transition: Transition.circularReveal,
          arguments: mapresponse!['token']);
    } else {
      return 'status code didnot match';
    }
  }

  DateTime backpressed = DateTime.now();
  // ignore: use_key_in_widget_constructors

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    // void toggle()=>setState(()=>isLogin = isLogin);

    final screenheight = MediaQuery.of(context).size.height;
    final screensize = MediaQuery.of(context).size;
    final screenwidth = MediaQuery.of(context).size.width;
    final tabbarheight = MediaQuery.of(context).padding.top;
    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(backpressed);
          final isexisting = difference >= Duration(seconds: 2);
          backpressed = DateTime.now();
          if (isexisting) {
            Fluttertoast.showToast(
                msg: "Press back again to exit", fontSize: 18);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: 700,
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      // margin: EdgeInsets.all(20),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Image.asset("images/BuddyCoachLogo.jpeg"),
                            SizedBox(
                              height: 50,
                            ),

                            Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ThemeData()
                                      .colorScheme
                                      .copyWith(primary: Color(0xff1F7A8C))),
                              child: TextFormField(
                                autofocus: true,
                                controller: emailcontroller,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Enter Email",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Color(0xff1F7A8C),
                                      )),
                                  prefixIcon: Icon(Icons.mail_outlined),
                                  suffixIcon: IconButton(
                                    icon:
                                        Icon(visiblility ? null : Icons.clear),
                                    onPressed: () {},
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(passwordfocus);
                                },
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z.-]+.[a-zA-Z]")
                                          .hasMatch(value)) {
                                    setState(() {
                                      visiblility = false;
                                    });
                                    if (value.isNotEmpty) {
                                      return ('Please enter valid email id ');
                                    }
                                    return "Email required";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ThemeData()
                                      .colorScheme
                                      .copyWith(primary: Color(0xff1F7A8C))),
                              child: TextFormField(
                                focusNode: passwordfocus,
                                controller: passwordcontroller,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: "Enter Password",
                                  // hintText: "Password",
                                  // hintStyle: TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Color(0xff1F7A8C),
                                      )),
                                  prefixIcon: Icon(
                                    Icons.key_outlined,
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(securetext
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined),
                                      onPressed: () {
                                        setState(() {
                                          securetext = !securetext;
                                        });
                                      }),
                                ),
                                obscureText: securetext,
                                obscuringCharacter: "*",
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password required";
                                  } else if (value.length < 8) {
                                    return "enter valid Password";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     TextButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       loginwithpinscreen()));
                            //         },
                            //         child: Text(
                            //           'Login with PIN',
                            //           style: TextStyle(
                            //             color: Color(0xff1F7A8C),
                            //           ),
                            //         )),
                            //     TextButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       forgrotpasswordscreen()));
                            //         },
                            //         child: Text(
                            //           'Forgot password?',
                            //           style: TextStyle(
                            //             color: Color(0xff1F7A8C),
                            //           ),
                            //         )),
                            //   ],
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: MaterialButton(
                                    onPressed: () {
                                      print("Email id validation starts here");
                                      if (formkey.currentState!.validate()) {
                                        userLogin(emailcontroller.text,
                                            passwordcontroller.text);
                                      } else {
                                        Get.defaultDialog(
                                          title: "Invalid Email/Password",
                                          titleStyle:
                                              TextStyle(color: Colors.red),
                                          content: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              "Please enter valid Email/Password to sign-in",
                                            ),
                                          ),
                                          textConfirm: "ok",
                                          confirmTextColor: Colors.white,
                                          onConfirm: () {
                                            Get.back();
                                          },
                                        );
                                        print('error');
                                      }
                                    },
                                    color: Color(0xff1F7A8C),
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text('Login',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
