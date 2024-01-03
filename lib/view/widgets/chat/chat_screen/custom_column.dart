import 'package:flutter/material.dart';

class ChatCustomColumn extends StatelessWidget {
  const ChatCustomColumn(this.children, {super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
