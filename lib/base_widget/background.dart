
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: context.height * 0.18,
                width: context.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(context.height * 10)),
                  color: AppColors.cusitclr,
                ),
              )
              // Image.asset(
              //   "assets/images/main_top.png",
              //   width: context.width * 0.5,
              //   color:Color.fromARGB(255, 0, 95, 113)),
              ),
       
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: context.height * 0.18,
                width: context.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(context.height * 10)),
                  color: AppColors.cusitclr,
                ),
              )
              // Image.asset(
              //   "assets/images/main_top.png",
              //   width: context.width * 0.5,
              //   color:Color.fromARGB(255, 0, 95, 113)),
              ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: context.width * 0.35,
              color: AppColors.cusitclr,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
