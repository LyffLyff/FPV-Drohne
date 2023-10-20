import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class PreviousFlights extends StatelessWidget {
  const PreviousFlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: context.appBarTheme.backgroundColor ?? Colors.grey.shade900,
            child: const Text("Previous Flights")),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: 20,
        separatorBuilder: (context, index) {
          return const VerticalSpace(
            height: 0,
          );
        },
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: const Text("20.10.23"),
              subtitle: Text(
                "Time: 20min",
                style: context.textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
