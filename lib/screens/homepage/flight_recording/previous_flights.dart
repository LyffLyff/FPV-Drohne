import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/user_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: FutureBuilder(
        future: UserProfileService()
            .getFlightDataSets(context.read<AuthProvider>().userId),
        builder: (context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data?.length ?? 0,
              separatorBuilder: (context, index) {
                return const VerticalSpace(
                  height: 0,
                );
              },
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(data?[index].keys.elementAt(0) ?? ""),
                    subtitle: Text(
                      "Time: ${data?[index]["Help"]}",
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            );
          }
          return const CircularLoadingIcon();
        },
      ),
    );
  }
}
