import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back"),
      ),
      body: ExpandablePanel(
        header: Text("Header"),
        collapsed: Text("Help 1"),
        expanded: Text("Stop"),
        controller: ExpandableController(initialExpanded: true),
      ),
    );
  }
}
