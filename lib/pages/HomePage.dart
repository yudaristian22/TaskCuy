import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskcuy/Custom/TodoCard.dart';
import 'package:taskcuy/Service/Auth_Service.dart';
import 'package:taskcuy/main.dart';
import 'package:flutter/material.dart';
import 'package:taskcuy/pages/AddTodo.dart';
import 'package:taskcuy/pages/profile.dart';
import 'package:taskcuy/pages/view_data.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: Text(
          "TaskCuy",
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          CircleAvatar(
            radius: 23,
            backgroundImage: getUserProfileImage(),
          ),
          SizedBox(
            width: 25,
          ),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  List<DocumentSnapshot> userTodos =
                      (snapshot.data as QuerySnapshot)
                          .docs
                          .where((doc) =>
                              doc['userId'] ==
                              FirebaseAuth.instance.currentUser?.uid)
                          .toList();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Schedule",
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      if (userTodos.isNotEmpty)
                        IconButton(
                          onPressed: () async {
                            var instance =
                                FirebaseFirestore.instance.collection('Todo');
                            List<Select> selectedCopy = List.from(selected);
                            for (int i = 0; i < selectedCopy.length; i++) {
                              if (selectedCopy[i].checkValue) {
                                await instance.doc(selectedCopy[i].id).delete();
                              }
                            }
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => HomePage()),
                );
              },
              child: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => AddTodoPage()),
                );
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => Profile()),
                );
              },
              child: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: "",
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> userTodos = (snapshot.data as QuerySnapshot)
              .docs
              .where((doc) =>
                  doc['userId'] == FirebaseAuth.instance.currentUser?.uid)
              .toList();
          if (userTodos.isEmpty) {
            // Tampilkan pesan ketika tidak ada tugas
            return Center(
                child: Text(
              "Create a new assignment!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ));
          }
          return ListView.builder(
            itemCount: userTodos.length,
            itemBuilder: (context, index) {
              IconData iconData;
              Color iconColor;
              Map<String, dynamic> document =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;
              switch (document["Category"]) {
                case "Work":
                  iconData = Icons.work;
                  iconColor = Colors.red;
                  break;
                case "WorkOut":
                  iconData = Icons.alarm;
                  iconColor = Colors.teal;
                  break;
                case "Food":
                  iconData = Icons.food_bank;
                  iconColor = Colors.blue;
                  break;
                case "Design":
                  iconData = Icons.design_services;
                  iconColor = Colors.blue;
                  break;
                default:
                  iconData = Icons.run_circle_outlined;
                  iconColor = Colors.red;
                  break;
              }
              selected.add(
                Select(id: snapshot.data!.docs[index].id, checkValue: false),
              );
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ViewData(
                        document: document,
                        id: snapshot.data!.docs[index].id,
                      ),
                    ),
                  );
                },
                child: TodoCard(
                  title: document["title"] == null
                      ? "Hey There"
                      : document["title"],
                  check: selected[index].checkValue,
                  iconBgColor: Colors.white,
                  iconColor: iconColor,
                  iconData: iconData,
                  time: "",
                  index: index,
                  onChange: onChange,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

ImageProvider getUserProfileImage() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && user.photoURL != null) {
    return NetworkImage(user.photoURL!);
  }

  return AssetImage("assets/5856.jpg");
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
