// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/auth/upgradeappscreen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String id = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool updateAvailable = false;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      await checkForUpdates();
      if (updateAvailable) {
        Navigator.pushReplacementNamed(context, UpgradeScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, DashboardScreen.id);
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
