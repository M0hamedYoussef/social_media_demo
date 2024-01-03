import 'package:flutter/material.dart';
import 'package:sm_project/core/const/colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.size = 30,
    this.fontWeight = FontWeight.w400,
  });
  final String text;
  final double size;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: size,
          height: 1.5,
          color: AppColors.darkBlue1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
