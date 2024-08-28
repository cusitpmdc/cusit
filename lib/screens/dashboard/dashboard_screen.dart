import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/admission/admission_screen.dart';
import 'package:cusit/screens/chat/user/chat_screen.dart';
import 'package:cusit/screens/dashboard/drawer_screen.dart';
import 'package:cusit/screens/dashboard/widgets/dashbuttons.dart';
import 'package:cusit/screens/program/programs_screen.dart';
import 'package:cusit/screens/prospectus/prospectus_screen.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey.shade100,
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: AppColors.cusitclr,
        elevation: 0,
        foregroundColor: AppColors.white,
        title: Image.asset(
          'assets/icons/Logowb.png',
          width: context.width * 0.3,
          height: context.height * 0.2,
        ),
        centerTitle: true,
        actions: [
         Padding(
            padding: EdgeInsets.only(right: context.width * 0.03),
            child: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.of(context).pushNamed(GuestChatScreen.id);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
                  child: Image.asset(
                    'assets/icons/city.png',
                    scale: 7,
                  ),
                ),
                Column(
                  children: [
                    DashboardButtons(
                        title: 'Apply for Admission',
                        onTap: () {
                          Navigator.of(context).pushNamed(AdmissionScreen.id);
                        },
                        icon: Icons.file_copy),
                    DashboardButtons(
                        title: 'View Prospectus',
                        onTap: () {
                          Navigator.of(context).pushNamed(ProspectusScreen.id);
                        },
                        icon: Icons.file_copy),
                    DashboardButtons(
                        title: 'Programs/Fee',
                        onTap: () {
                          Navigator.of(context).pushNamed(ProgramsFeeScreen.id);
                        },
                        icon: Icons.file_copy)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
