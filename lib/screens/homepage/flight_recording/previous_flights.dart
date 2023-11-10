import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/previous_flight.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class PreviousFlights extends StatelessWidget {
  List? data;

  PreviousFlights({
    super.key,
    this.data,
  });

  Future<List?> getRecords(BuildContext context) async {
    // fetching data:
    // if empty records -> read from db
    // if local timestamp (flightRecordsAge) is older (<) than the one in the database
    final dataCache = Provider.of<DataCache>(context);
    final userId = context.read<AuthProvider>().userId;
    final bool emptyFlightRecords =
        Provider.of<DataCache>(context).previousFlights.isEmpty;

    Logger().i(dataCache.previousFlightsAge);

    // checking if data needs to be reloaded
    if (dataCache.previousFlightsAge <
            (await UserProfileService().fetchDataAge(
                    userId: userId, timestampKey: "flight_data_age") ??
                -1) ||
        emptyFlightRecords) {
      // data either older than on db or non-existent
      return UserProfileService().getFlightDataSets(userId);
    }

    // up to date flight records -> no reload from db
    Logger().i("VALID DATA");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: context.appBarTheme.backgroundColor ?? Colors.grey.shade900,
            child: const Text("Previous Flights")),
      ),
      body: FutureBuilder(
        // loading data either from Database or from Server
        future: getRecords(context),
        builder: (context, AsyncSnapshot<List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData == false) {
            Logger().i("Fetching local data");
            // no connection -> data cached
            data = Provider.of<DataCache>(context).previousFlights;
          } else if (snapshot.hasData) {
            // snapshot received data from future
            data = snapshot.data;
            Provider.of<DataCache>(context)
                .setPreviousFlights(data!); // set data in cache
          }
          if (data != null) {
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
                    title: Text(data?[index]["title"] ?? ""),
                    subtitle: Text(
                      "Duration: ${(((data?[index]["endTimestamp"] - data?[index]["startTimestamp"]) / 1000) as double).round()} seconds",
                      style: context.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Logger().i(data?[0]);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PreviousFlight(
                          flightData: data?[index] ?? {},
                        ),
                      ));
                    },
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
