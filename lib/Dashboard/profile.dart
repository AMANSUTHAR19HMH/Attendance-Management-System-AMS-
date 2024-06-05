import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:attendance_management_system_ams/resources/savedata.dart';

void main() {
  runApp(Profile());
}

import 'DashBoard.dart';


class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'edit profile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const editprofile(),
    );
  }
}

class editprofile extends StatefulWidget {
  const editprofile({super.key});

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  final TextEditingController fullname_value = TextEditingController();
  final TextEditingController email_value = TextEditingController();

// selectin image for profile from the Local Gallery //
  Uint8List? profileimage;
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? proflieimg = await imagePicker.pickImage(source: source);
    if (proflieimg != null) {
      return await proflieimg.readAsBytes();
    } else {
      print("no Image picked");
    }
  }

  // image from pickimage ()//
  Future<void> selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      profileimage = img;
    });
  }

  // Save Profile to the Database using Firebase //
  void saveprofile() async {
    String name = fullname_value.text;
    String email = email_value.text;
    String resp = await StoreData().saveData(
      name: name,
      email: email,
      file: profileimage!,
    );
  }

  bool showpassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: //Back button to navigate to home page//
            IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purple,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: profileimage != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(profileimage!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage('/Image/assest/jackwilliam.png'),
                            ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.purple,
                            ),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.penToSquare,
                                color: Colors.white,
                              ),
                              onPressed: selectImage,
                            )))
                  ],
                ),
              ),
              mainText(fullname_value, 'Enter Your Name', false),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Dashboard');
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveprofile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shadowColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                    ),
                    child: Text("SAVE",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainText(TextEditingController labelText, String placeholder,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: fullname_value,
        obscureText: isPasswordTextField ? showpassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    //Function for Password Icon //
                    onPressed: () {
                      setState(() {
                        showpassword = !showpassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.purple,
                    ))
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
      ),
    );
  }
}
