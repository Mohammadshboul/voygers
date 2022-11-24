import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voygares/compononet/colors.dart';
import '../compononet/catagory/catagoryList.dart';
import '../utils/binding/HomeBinding.dart';
import 'bottom_appbar.dart';
import 'home_screen.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

bool? endTrip;

class StructureScreen extends StatefulWidget {
  const StructureScreen({super.key});

  @override
  State<StructureScreen> createState() => _StructureScreenState();
}

class _StructureScreenState extends State<StructureScreen> {
  final Uri _url = Uri.parse('https://mail.google.com/mail/u/0/#sent');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  // ____________________________________________________________________________________________
  final currentUser = FirebaseAuth.instance;
  String email = "";
  String phoneNum = "";
  String name = "";
  int i = 0;
  List tools1 = [];
  CollectionReference toolsInTrip =
      FirebaseFirestore.instance.collection("tools per trip");
  CollectionReference commentDb =
      FirebaseFirestore.instance.collection("comments");
  // _______________________________________end trip______________________________________________________
  AddEndTripField() {
    DocumentReference tripDb =
        FirebaseFirestore.instance.collection("trips").doc(logic1);

    Map<String, dynamic> tripEnd = {
      "ended trip": "true",
    };
    tripDb.update(tripEnd);
    print("added sucessfulle");
  }

  List UsersListdocuments = [];
  String? userdocument;

  DeleteUsersTripId() {
    CollectionReference usersDb =
        FirebaseFirestore.instance.collection("users");
    usersDb.where("trip_id", isEqualTo: logic1).get().then(
        (QuerySnapshot snapshot) =>
            snapshot.docs.forEach((DocumentSnapshot doc) {
              UsersListdocuments.add(doc.id);

              print(
                  "5555555555555555555555555555555555555 ${UsersListdocuments} 55555555555555555555555555555555555555555555555");
              for (var i = 0; i < UsersListdocuments.length; i++) {
                userdocument = UsersListdocuments[i];
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(userdocument)
                    .update({
                  "old_trip": logic1,
                });
                print("old trip added ");
                print(
                    "________________________________________________________________________________");

                print("trip_id is deleted");
              }
              for (var i = 0; i < UsersListdocuments.length; i++) {
                userdocument = UsersListdocuments[i];
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(userdocument)
                    .update({
                  "trip_id": null,
                });
                print("old trip added ");
                print(
                    "________________________________________________________________________________");

                print("trip_id is deleted");
              }
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    CollectionReference usersDb =
        FirebaseFirestore.instance.collection("users");
    usersDb.where("trip_id", isEqualTo: logic1).get().then(
        (QuerySnapshot snapshot) =>
            snapshot.docs.forEach((DocumentSnapshot doc) {
              UsersListdocuments.add(doc.id);
              print(
                  "5555555555555555555555555555555555555 ${UsersListdocuments} 55555555555555555555555555555555555555555555555");
            }));

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: 200,
        height: 500,
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(1000),
              topLeft: Radius.circular(1000),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 123,
                top: 30,
                right: 20,
                child: Text(
                  "Tools",
                  style: GoogleFonts.aclonica(
                      textStyle: TextStyle(
                    fontSize: 20,
                    color: primary_color,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("tools per trip")
                    .where("trip_id", isEqualTo: userTripId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshots) {
                  if (snapshots.hasData) {
                    return ListView.builder(
                        // shrinkWrap: true,
                        itemCount: snapshots.data.docs.length,
                        itemBuilder: (context, i) {
                          QueryDocumentSnapshot x = snapshots.data!.docs[i];

                          tools1.add(x['tool'][i]);

                          return Container(
                            width: 10,
                            height: 50,
                            // color: primary_color,
                            child: Center(
                              child: Text(
                                x['tool'].toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                          );
                        });
                  }

                  return Container(
                    child: Text(""),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "voygers",
          style: GoogleFonts.aclonica(
              textStyle: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
        ),
        elevation: 0,
        backgroundColor: primary_color,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _scaffoldKey.currentState!.openEndDrawer();
              });
            },
            // onPressed: () => Navigator.pop(
            //   context,
            // ),
            icon: Lottie.asset("images/panda.json"),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: primary_color,
        child: Stack(
          children: [
            // Image(image: AssetImage("images/food.png")),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("uid", isEqualTo: currentUser.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[index];
                        return Container(
                            child: DrawerHeader(
                          child: Column(children: [
                            Container(
                              width: 80,
                              height: 80,
                              child: CircleAvatar(
                                radius: 71,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      Color.fromRGBO(76, 175, 80, 1),
                                  backgroundImage: logic1 == null
                                      ? null
                                      : NetworkImage("${x['profile image']}"),
                                ),
                              ),

                              //  CircleAvatar(
                              //     backgroundImage:
                              //         NetworkImage(x['profile image'])),
                            ),
                            Text(x['Email']),
                            Text(x['Name']),
                            Text(x['phone'])
                          ]),
                        ));
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            DrawerHeader(
                child: Column(
              children: [Text(name), Text(email), Text(phoneNum)],
            )),
            Positioned(
              top: 250,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "history");
                },
                icon: Icon(Icons.history, color: Colors.white),
                label: Text(
                  "Old Trips",
                  style: TextStyle(
                      color: Color.fromARGB(255, 245, 206, 252), fontSize: 25),
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "Trip_Comment");
                },
                icon: Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
                label: Text(
                  "Comment On trip",
                  style: TextStyle(
                      color: Color.fromARGB(255, 245, 206, 252), fontSize: 25),
                ),
              ),
            ),
            Positioned(
              top: 350,
              child: TextButton.icon(
                  icon: Icon(
                    Icons.snowing,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.to(HomeScreen(), binding: HomeBinding());
                  },
                  label: Text(
                    "weather",
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 206, 252),
                        fontSize: 25),
                  )),
            ),
            Positioned(
              top: 500,
              child: Visibility(
                // visible: creater == 1 ? true : false,
                visible: endTrip!,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: primary_color,
                              title: Text(
                                "Are you Sure you want to end trip?",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Row(children: [
                                TextButton(
                                  onPressed: () async {
                                    // __________________________end trip  putton____________________________________________________________________
                                    AddEndTripField();
                                    DeleteUsersTripId();

                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: primary_color,
                                          title: Text(
                                            "hve fun ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          // content: TextButton(
                                          //   onPressed: () {
                                          //     Navigator.pushReplacement(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               MainPage(),
                                          //         ));
                                          //   },
                                          //   child: Text(
                                          //     "press to enjoy in another trip",
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //   ),
                                          // ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                // __________________________________________________________________________________________________________________________________

                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]),
                            );
                          });
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: Text(
                    "End trip",
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 206, 252),
                        fontSize: 25),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 400,
              child: TextButton.icon(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                  label: Text(
                    "send trip info",
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 206, 252),
                        fontSize: 25),
                  )),
            ),
            Positioned(
              top: 450,
              child: TextButton.icon(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    UrlLauncher.launch("tel://911");
                  },
                  label: Text(
                    "emergency call",
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 206, 252),
                        fontSize: 25),
                  )),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 30),
          child: ListView(
            children: [
              // ____________________________________CarouselSlider________________________________________________________________
              StreamBuilder(
                stream: commentDb
                    .where("trip_id", isEqualTo: userTripId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    List commentInfo = snapshot.data!.docs;
                    return CarouselSlider.builder(
                      itemCount: commentInfo.length,
                      itemBuilder:
                          (BuildContext context, i, int pageViewIndex) {
                        if (commentInfo.isEmpty) {
                          return Lottie.asset("images/panda.json",
                              height: 500, width: 500);
                        } else {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: primary_color,
                              border: GradientBoxBorder(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                width: 4.0,
                              ),
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        commentInfo[i]['subject'],
                                        style: GoogleFonts.aclonica(
                                            textStyle: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      commentInfo[i]['comment'],
                                      style: GoogleFonts.aclonica(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      options: CarouselOptions(
                        height: 150,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  return Lottie.asset("images/panda.json");
                },
              ),

              SizedBox(
                height: 30,
              ),
              //  ____________________________________________________________________________________________________________________
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Services",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CategoryList(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
