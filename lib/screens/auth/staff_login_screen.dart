// ignore_for_file: use_build_context_synchronously

import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:cusit/utils/app_dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _loginIndicator = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loginIndicator = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      User? user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('loginTime', DateTime.now().toIso8601String());
        prefs.setString('userId', user.uid); // Store the user ID

        Navigator.of(context)
            .pushReplacementNamed(DashboardScreen.id); // Navigate to dashboard
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppDimensions.large),
          ),
        ),
      );
    } finally {
      setState(() {
        _loginIndicator = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/logon.png",
              width: context.width * 0.4,
              height: context.height * 0.17,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.1),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            TextFormField(
                              style: TextStyle(
                                  fontSize: AppDimensions.normal,
                                  color: AppColors.dblue),
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
                                  color: AppColors.dblue,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              style: TextStyle(
                                  fontSize: AppDimensions.normal,
                                  color: AppColors.dblue),
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
                                  color: AppColors.dblue,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.dblue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
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
                           
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: context.height * 0.005),
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.dblue,
                                  elevation: 0,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(context.height * 0.013),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      _loginIndicator
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: CupertinoActivityIndicator(
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
                            SizedBox(height: size.height * 0.015),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'For any query email us at ',
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                  TextSpan(
                                    text: 'culms@cusit.edu.pk',
                                    style:
                                        const TextStyle(color: AppColors.dbrown),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Add email functionality
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
