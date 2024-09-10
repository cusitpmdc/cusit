import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/auth/upgradeappscreen.dart';
import 'package:cusit/screens/chat/staff/staffdashboard_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Firebase Auth import
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String id = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool updateAvailable = false;
  bool isStaff = false;  // Boolean to track if the user is staff

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

  // Check if the user is logged in and determine if they are a staff member
  Future<void> checkUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check Firestore if the user is a staff member
        final firestore = FirebaseFirestore.instance;
        final snapshot = await firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null && data['role'] == 'staff') {
            setState(() {
              isStaff = true;
            });
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
      await checkUserRole();  // Check user role before navigating
      if (mounted) {
        if (updateAvailable) {
          Navigator.pushReplacementNamed(context, UpgradeScreen.id);
        } else if (isStaff) {
          Navigator.pushReplacementNamed(context, StaffDashBoardScreen.id);  // Navigate to Staff Dashboard if staff
        } else {
          Navigator.pushReplacementNamed(context, DashboardScreen.id);  // Navigate to normal dashboard if not staff
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
