import 'package:flutter/material.dart';

class HomePageTabs extends StatelessWidget {
  final int currentPageIdx;
  final List<Widget> pages;

  const HomePageTabs(
      {super.key, required this.currentPageIdx, required this.pages});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentPageIdx,
      children: pages,
    );
  }
}
