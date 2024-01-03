import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddedMedia extends StatelessWidget {
  const AddedMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsCon>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: controller.vidImg,
      ),
    );
  }
}
