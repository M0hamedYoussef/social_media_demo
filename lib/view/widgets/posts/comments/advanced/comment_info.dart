import 'package:flutter/material.dart';
import 'package:sm_project/core/const/colors.dart';

class CommentInfoRow extends StatelessWidget {
  const CommentInfoRow({
    super.key,
    required this.pfp,
    required this.username,
    required this.date,
  });
  final String pfp;
  final String username;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.black,
          backgroundImage: NetworkImage(
            pfp,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(date),
            ],
          ),
        ),
      ],
    );
  }
}
