import 'package:flutter/material.dart';

class AddPostsListView extends StatelessWidget {
  const AddPostsListView({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFillRemaining(
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
