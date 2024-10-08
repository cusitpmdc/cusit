// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/chat/staff/staffdashboard_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:cusit/utils/app_dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool invalidCredentials = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool loginIndicator = false;
  bool loginSuccess = false;
  // var connectivityResult;

  checkInternetConnection() async {
    // connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   // connected to a mobile network.
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   // connected to a wifi network.
    // } else {
    //   setState(() {
    //     loginIndicator = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //     'Please Check your internet connection!',
    //     textAlign: TextAlign.center,
    //   )));
    // }
  }
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.red,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppDimensions.large,
        ),
      ),
    ));
  }

  late bool loading;
  @override
  void initState() {
    super.initState();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.cusitclr,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: context.height * 0.12),
                child: Image.asset(
                  "assets/icons/Logosmall.png",
                  scale: 1.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.07,
                    vertical: context.height * 0.05),
                child: SingleChildScrollView(
                  child: Container(
                    color: AppColors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: context.height * 0.07,
                          horizontal: context.width * 0.02),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: StreamBuilder<Object>(
                            stream: null,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: AppDimensions.normal,
                                      color: AppColors.cusitclr,
                                    ),
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      labelText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: AppColors.cusitclr,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return 'Please enter your Email';
                                      }
                                      // A simple email validation
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value.trim())) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: context.height * 0.02),
                                  TextFormField(
                                    style: TextStyle(
                                        fontSize: AppDimensions.normal,
                                        color: AppColors.cusitclr),
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: AppColors.cusitclr,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.cusitclr,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      labelText: 'Password',
                                    ),
                                    obscureText: !_passwordVisible,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          '',
                                          style: TextStyle(
                                              color: AppColors.cusitclr),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: context.height * 0.005,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus(); // To dismiss the keyboard

                                        final FormState? formStateVal =
                                            _formKey.currentState;

                                        // Check if the form is valid when the user tries to submit
                                        if (formStateVal!.validate()) {
                                          setState(() {
                                            loginIndicator =
                                                true; // Show loading indicator
                                          });

                                          try {
                                            // Attempt sign-in with FirebaseAuth
                                            UserCredential userCredential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                              email: emailController.text
                                                  .trim(), // Trim to avoid spaces
                                              password: passwordController.text
                                                  .trim(),
                                            );

                                            User? user = userCredential.user;

                                            if (user != null) {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString(
                                                  'loginTime',
                                                  DateTime.now()
                                                      .toIso8601String());
                                              prefs.setString(
                                                  'userId', user.uid);

                                              // Store user data in Firestore
                                              await _firestore
                                                  .collection('users')
                                                  .doc(user.uid)
                                                  .set({
                                                'email': user.email,
                                                'lastLogin': DateTime.now(),
                                              });

                                              // Navigate to dashboard after successful login
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      StaffDashBoardScreen.id);
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            // Handle specific Firebase Auth errors
                                            if (e.code == 'user-not-found' ||
                                                e.code == 'wrong-password') {
                                              showErrorSnackbar(context,
                                                  'Invalid credentials. Please try again.');
                                            } else {
                                              showErrorSnackbar(context,
                                                  'An error occurred. Please try again.');
                                            }
                                          } finally {
                                            setState(() {
                                              loginIndicator =
                                                  false; // Hide loading indicator
                                            });
                                          }

                                          // Optionally, check the internet connection
                                          checkInternetConnection();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.cusitclr,
                                        elevation: 0,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            context.height * 0.013),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Login',
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: AppDimensions.normal,
                                              ),
                                            ),
                                            loginIndicator
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color: AppColors.white,
                                                      radius: 8.5,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.height * 0.015),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'For any query email us at ',
                      style: TextStyle(color: AppColors.greyy),
                    ),
                    TextSpan(
                      text: 'culms@cusit.edu.pk',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.white),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // SendEmailService.sendEmail();
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
