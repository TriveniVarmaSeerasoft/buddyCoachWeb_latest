import 'package:buddycoachweb_latest/webTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class conceptNotLearned extends StatefulWidget {
  const conceptNotLearned({super.key});

  @override
  State<conceptNotLearned> createState() => _conceptNotLearnedState();
}

class _conceptNotLearnedState extends State<conceptNotLearned> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Color(
            0xff2D3142,
          )),
          child: Padding(
            padding: EdgeInsets.all(80),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5GqJhCPYeRpx_456iXN_bHMWVpQbqtcDreQ&usqp=CAU",
                    ),
                    width: 130,
                    height: 130,
                  ),
                  Text(
                    "Buddy Coach",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1F7A8C)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Welcome, User",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2D3142)),
                    ),
                  ),
                  Text(
                    "Concept not learned",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4F5D75)),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(webTask());
                    },
                    child: Text(
                      "Let's complete",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff1F7A8C),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
