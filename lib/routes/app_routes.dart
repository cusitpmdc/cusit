import 'package:cusit/screens/auth/splash_screen.dart';
import 'package:cusit/screens/auth/staff_login_screen.dart';
import 'package:cusit/screens/auth/upgradeappscreen.dart';
import 'package:cusit/screens/admission/admission_screen.dart';
import 'package:cusit/screens/chat/staff/staffdashboard_screen.dart';
import 'package:cusit/screens/chat/user/guestchat_screen.dart';
import 'package:cusit/screens/dashboard/dashboard_screen.dart';
import 'package:cusit/screens/program/programs_screen.dart';
import 'package:cusit/screens/prospectus/prospectus_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.id: (context) => const SplashScreen(),
    LoginScreen.id: (context) => const LoginScreen(),
    StaffDashBoardScreen.id: (context) => const StaffDashBoardScreen(),
    UpgradeScreen.id: (context) => const UpgradeScreen(),
    DashboardScreen.id: (context) => const DashboardScreen(),
    AdmissionScreen.id: (context) => const AdmissionScreen(),
    ProspectusScreen.id: (context) => const ProspectusScreen(),
    ProgramsFeeScreen.id: (context) => const ProgramsFeeScreen(),
     GuestChatScreen.id: (context) => GuestChatScreen(
          staffId: ModalRoute.of(context)!.settings.arguments as String,
        ),
  };
}
