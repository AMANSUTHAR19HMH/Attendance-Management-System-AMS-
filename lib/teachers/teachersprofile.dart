import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:attendance_management_system_ams/teachers/TeacherDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class teachersprofile extends StatefulWidget {
  const teachersprofile({super.key});

  @override
  State<teachersprofile> createState() => _teachersprofileState();
}

class _teachersprofileState extends State<teachersprofile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Get.to(TeacherDashboard());
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              // onTap: () {
              //   pickImage(ImageSource.gallery);
              // },
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurple,
                      ),
                      // child: profileImage != null && profileImage!.isNotEmpty
                      //     ? ClipOval(
                      //         child: Image.memory(
                      //           profileImage!,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       )
                      //     : const Icon(
                      //         Icons.person,
                      //         size: 60,
                      //         color: Colors.white,
                      //       ),
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.deepPurple,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
                fullNameController, "Full Name", "Enter your Full Name"),
            _buildTextField(emailController, "Email", "Enter your Email"),
            _buildTextField(
                phoneController, "Phone no", "Please Enter 10 digits"),
            _buildTextField(
                passwordController, "Password", "Enter Your Password",
                isPassword: true),
            _buildTextField(
                addressController, "Address", "Please Enter Address"),
            _buildTextField(
                departmentController, "Department", "Working Department"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Cancel action
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.deepPurple),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // saveProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shadowColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String placeholder,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    // setState(() {
                    //   showPassword = !showPassword;
                    // });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.deepPurple,
                  ),
                )
              : null,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
