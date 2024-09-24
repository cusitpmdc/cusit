import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/admission/admission_screen.dart';
import 'package:cusit/screens/auth/staff_login_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/screens/program/programs_screen.dart';
import 'package:cusit/screens/prospectus/prospectus_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_dimensions.dart';

class DrawerScreen extends StatefulWidget {
  static const String id = 'Drawer_screen';
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isStaff = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserRole();
    });
  }

  Future<void> checkUserRole() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Check current user

    if (currentUser != null) {
      // Fetch the user document from Firestore using the user's UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Adjust this path to your Firestore structure
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Check if the user has a 'role' field set as 'staff'
        setState(() {
          isStaff = userDoc.get('role') == 'staff';
        });
      }
    }

    setState(() {
      isLoading = false; // Finish loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.cusitclr2,
        child: ListView(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(28.r),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.r),
                    child: Card(
                      elevation: 0,
                      child: Image.asset(
                        'assets/icons/city.png',
                        height: context.height * 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, DashboardScreen.id);
              },
              child: ListTile(
                leading: Icon(
                  Icons.dashboard_sharp,
                  size: 16.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.normal),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AdmissionScreen.id);
              },
              child: ListTile(
                leading: Icon(
                  Icons.file_copy,
                  size: 16.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Apply for Admission',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.normal),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProspectusScreen.id);
              },
              child: ListTile(
                leading: Icon(
                  Icons.folder,
                  size: 16.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'View Prospectus',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.normal),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProgramsFeeScreen.id);
              },
              child: ListTile(
                leading: Icon(
                  Icons.file_copy,
                  size: 16.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Programs Offered/Fee',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.normal),
                ),
              ),
            ),
            if (!isStaff)
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 16.r,
                    color: AppColors.white,
                  ),
                  title: Text(
                    'Staff',
                    style: TextStyle(
                        color: AppColors.white, fontSize: AppDimensions.normal),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
