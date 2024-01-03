import 'package:flutter/material.dart';
import 'package:sm_project/core/const/colors.dart';

class CustomColumn extends StatelessWidget {
  const CustomColumn({super.key, required this.fst, required this.children});
  final GlobalKey<FormState> fst;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: fst,
        child: Container(
          color: AppColors.white,
          width: double.infinity,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
