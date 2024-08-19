import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/admission/admission_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/screens/program/programs_screen.dart';
import 'package:cusit/screens/prospectus/prospectus_screen.dart';
import 'package:cusit/utils/app_colors.dart';
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
  bool loading = false;
  bool loginIndicator = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
                  size: 15.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.small),
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
                  size: 15.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Apply for Admission',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.small),
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
                  size: 15.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'View Prospectus',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.small),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProgramsFeeScreen.id);
              },
              child: ListTile(
                leading: Icon(
                  Icons.folder,
                  size: 15.r,
                  color: AppColors.white,
                ),
                title: Text(
                  'Programs Offered/Fee',
                  style: TextStyle(
                      color: AppColors.white, fontSize: AppDimensions.small),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
