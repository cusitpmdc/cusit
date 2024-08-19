import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';

class DashboardButtons extends StatelessWidget {
  const DashboardButtons(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);

  final String title;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical:context.height*0.02),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.cusitclr, AppColors.cusitclr2,
              //  AppColors.dblue
            ],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(context.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: context.height * 0.025,
                ),
                Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 1.5,
                    color: AppColors.white,
                    fontSize: AppDimensions.normal,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: context.height * 0.025,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
