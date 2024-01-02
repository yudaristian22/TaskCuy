import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taskcuy/Service/Auth_Service.dart';
import 'package:taskcuy/pages/HomePage.dart';
import 'package:taskcuy/pages/SignUpPage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  AuthClass authClass = AuthClass();
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black87,
            elevation: 0, // Remove shadow
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => HomePage()));
              },
            ),
            title: Center(
              child: Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await authClass.signOut(context: context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => SignUpPage(),
                      ),
                      (route) => false);
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.black87),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: getImage(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Tampilkan email atau akun Google
                        Text(
                          user?.email ?? 'Email not available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: () async {
                            XFile? pickedImage = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedImage != null) {
                              // Upload the image to Firebase Storage
                              await uploadImageToFirebase(pickedImage);
                            }
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.teal,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Spacer(), // Memberikan ruang di antara elemen
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImageToFirebase(XFile pickedImage) async {
    try {
      String fileName =
          '${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      await storageReference.putFile(File(pickedImage.path));
      String imageUrl = await storageReference.getDownloadURL();

      // Update the user's photoURL in Firebase Auth
      await user!.updatePhotoURL(imageUrl);

      setState(() {
        image = pickedImage;
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  ImageProvider getImage() {
    if (image != null) {
      return FileImage(File(image!.path));
    } else if (user != null && user!.photoURL != null) {
      return NetworkImage(user!.photoURL!);
    }
    return AssetImage('assets/5856.jpg');
  }
}
