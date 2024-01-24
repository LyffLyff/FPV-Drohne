import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/previous_flight.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

enum SortingTypes {
  title,
  duration,
  date,
}

// ignore: must_be_immutable
class PreviousFlights extends StatefulWidget {
  const PreviousFlights({
    super.key,
  });

  @override
  State<PreviousFlights> createState() => _PreviousFlightsState();
}

class _PreviousFlightsState extends State<PreviousFlights> {
  List? originalData;
  List? data;
  SortingTypes sortType = SortingTypes.title;
  bool dataLoaded = false;

  Future<List?> _getRecords(BuildContext context) async {
    // fetching data:
    // if empty records -> read from db
    // if local timestamp (flightRecordsAge) is older (<) than the one in the database
    final dataCache = Provider.of<DataCache>(context);
    final userId = context.read<AuthenticationProvider>().userId;
    final bool emptyFlightRecords =
        Provider.of<DataCache>(context).previousFlights.isEmpty;

    // checking if data needs to be reloaded
    if (dataCache.dataAges["previousFlights"] <
            (await UserProfileService().fetchDataAge(
                    userId: userId, timestampKey: "flight_data_age") ??
                -1) ||
        emptyFlightRecords) {
      // data either older than on db or non-existent
      return UserProfileService().getFlightDataSets(userId);
    }

    // up to date flight records -> no reload from db
    return null;
  }

  int _getDurationInSeconds(int index) {
    return (data?[index]["endTimestamp"] - data?[index]["startTimestamp"]) ~/
        1000;
  }

  Expanded _getHeaderButton(String text, SortingTypes type) {
    return Expanded(
      child: TextButton(
        child: Text(text),
        onPressed: () {
          setState(() {
            sortType = type;
          });
        },
      ),
    );
  }

  Widget _getListHeader() {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getHeaderButton("Title", SortingTypes.title),
          _getHeaderButton("Duration", SortingTypes.duration),
          _getHeaderButton("Date", SortingTypes.date),
        ],
      ),
    );
  }

  void _sortData() {
    switch (sortType) {
      case SortingTypes.title:
        data?.sort((a, b) => b["title"].compareTo(a["title"]));
        break;
      case SortingTypes.duration:
        data?.sort((a, b) => (b["endTimestamp"] - b["startTimestamp"])
            .compareTo((a["endTimestamp"] - a["startTimestamp"])));
        break;
      case SortingTypes.date:
        data?.sort((a, b) => b["endTimestamp"].compareTo(a["endTimestamp"]));
        break;
      default:
        Logging.error("Error, Invalid Sorting Type");
        break;
    }
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
        future: dataLoaded ? null : _getRecords(context),
        builder: (context, AsyncSnapshot<List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData == false &&
              !dataLoaded) {
            Logging.info("Fetching local data");
            // no connection -> data cached
            originalData =
                data = Provider.of<DataCache>(context).previousFlights;
            dataLoaded = true;
          } else if (snapshot.hasData && !dataLoaded) {
            // snapshot received data from future
            originalData = data = snapshot.data;
            dataLoaded = true;
            Provider.of<DataCache>(context)
                .setPreviousFlights(data!); // set data in cache
          }
          if (data != null) {
            // sorting data
            _sortData();

            // displaying data
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data!.length + 1,
              separatorBuilder: (context, index) {
                return const VerticalSpace(
                  height: 0,
                );
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  // building header
                  return _getListHeader();
                }

                index = index - 1; // setting index back to normal value
                String weatherIcon = data?[index]["weather"] ?? "wi-day-sunny";
                return Column(
                    children: [
                  Divider(
                      height: 8,
                      thickness: 1,
                      color: Colors.grey.shade900,
                      endIndent: 8,
                      indent: 8),
                  ListTile(
                    leading: Image.asset(
                      "${context.read<ThemeManager>().getWeatherIconPath()}$weatherIcon.png",
                    ),
                    title: Text(data?[index]["title"] ?? ""),
                    subtitle: Text(
                      "Duration: ${_getDurationInSeconds(index)} seconds",
                      style: context.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PreviousFlight(
                          flightData: data?[index] ?? {},
                        ),
                      ));
                    },
                  ),
                ].animate(interval: 200.ms).fade(duration: 100.ms));
              },
            );
          }
          return const CircularLoadingIcon();
        },
      ),
    );
  }
}
