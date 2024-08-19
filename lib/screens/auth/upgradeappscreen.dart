import 'dart:developer';
import 'dart:io';

import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:cusit/utils/app_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeScreen extends StatefulWidget {
  static const String id = 'update_Screen';

  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  late bool loading;
  bool loginIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/update.png",
              height: context.height * 0.55,
              width: context.width,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "New Update is Available",
                    style: TextStyle(
                      fontSize: AppDimensions.extralarge,
                      color: AppColors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 100.w),
                    child: Text(
                      "Its time to update app new features is waiting for you. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.extralarge,
                        color: AppColors.blacklight,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        loginIndicator = true;
                      });
                      if (Platform.isAndroid) {
                        if (await canLaunchUrl(Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.cusit.cusit"))) {
                          await launchUrl(
                              Uri.parse(
                                  "https://play.google.com/store/apps/details?id=com.cusit.cusit"),
                              mode: LaunchMode.externalNonBrowserApplication);
                          setState(() {
                            loginIndicator = false;
                          });
                        } else {
                          log("could not launch Url..!!");
                          setState(() {
                            loginIndicator = false;
                          });
                        }
                      } else {
                        if (await canLaunchUrl(Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.cusit.cusit"))) {
                          await launchUrl(
                              Uri.parse(
                                  "https://play.google.com/store/apps/details?id=com.cusit.cusit"),
                              mode: LaunchMode.externalNonBrowserApplication);
                          setState(() {
                            loginIndicator = false;
                          });
                        } else {
                          log("could not launch Url..!!");
                          setState(() {
                            loginIndicator = false;
                          });
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.cusitclr,
                            AppColors.cusitclr,
                            AppColors.cusitclr2
                            // Color(0xff002a32),
                            // Color(0xff1b648d),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Click for App Update",
                                style: TextStyle(
                                  fontSize: AppDimensions.large,
                                  color: AppColors.white,
                                ),
                              ),
                              loginIndicator
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 8.r),
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.white,
                                        radius: 8.5.r,
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
