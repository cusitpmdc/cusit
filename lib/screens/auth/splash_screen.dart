import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/auth/upgradeappscreen.dart';
import 'package:cusit/screens/chat/staff/staffdashboard_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String id = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool updateAvailable = false;
  bool isStaff = false; // Boolean to track if the user is staff

  // Check for updates in Firestore
  Future<void> checkForUpdates() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('update_app').get();
      final document = snapshot.docs.first;
      final data = document.data();
      final version = data['android_latest_version'].split('.');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var currentVersion = packageInfo.version.split('.');

      log('CURRENT VERSION::: $currentVersion FIREBASE VERSION ::: $version');
      for (int i = 0; i < version.length || i < currentVersion.length; i++) {
        if (int.parse(version[i]) > int.parse(currentVersion[i])) {
          setState(() {
            updateAvailable = true;
          });
          break;
        }
      }
    } catch (e) {
      log('ERROR IN FIREBASE::: $e');
    }
  }

  Future<void> checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      log("User is logged in? ${user != null}");

      if (user != null) {
        String? savedRole = prefs.getString('userRole');

        if (savedRole == null) {
          final firestore = FirebaseFirestore.instance;
          final snapshot =
              await firestore.collection('users').doc(user.uid).get();

          if (snapshot.exists) {
            final data = snapshot.data();
            log('User data from Firestore: $data');

            if (data != null && data['role'] != null) {
              String role = data['role'];

              prefs.setString('userRole', role);

              if (role == 'staff') {
                setState(() {
                  isStaff = true;
                });
                log('User is a staff member');
              } else {
                log('User is not a staff member');
              }
            } else {
              log('No role data found for this uid in Firestore');
            }
          } else {
            log('No user data found for this uid in Firestore');
          }
        } else {
          log('User role retrieved from SharedPreferences: $savedRole');
          if (savedRole == 'staff') {
            setState(() {
              isStaff = true;
            });
            log('User is a staff member (cached)');
          } else {
            log('User is not a staff member (cached)');
          }
        }
      }
    } catch (e) {
      log('ERROR CHECKING USER ROLE::: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      await checkForUpdates();
      await checkUserRole();
      if (mounted) {
        if (updateAvailable) {
          Navigator.pushReplacementNamed(context, UpgradeScreen.id);
        } else if (isStaff) {
          log('Navigating to StaffDashBoardScreen');
          Navigator.pushReplacementNamed(context, StaffDashBoardScreen.id);
        } else {
          log('Navigating to DashboardScreen');
          Navigator.pushReplacementNamed(context, DashboardScreen.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cusitclr,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: context.height * 0.6,
            width: context.width * 0.6,
            child: Image.asset(
              'assets/icons/Logowb.png',
            ),
          ),
        ),
      ),
    );
  }
}
