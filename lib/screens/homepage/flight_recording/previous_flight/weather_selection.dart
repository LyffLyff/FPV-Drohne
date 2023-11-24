import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class WeatherSelection extends StatefulWidget {
  const WeatherSelection({super.key});

  @override
  State<WeatherSelection> createState() => _WeatherSelectionState();
}

class _WeatherSelectionState extends State<WeatherSelection> {
  final List<String> _icons = ["wi-cloud", "wi-day-sunny", "wi-horizon-alt", "wi-sprinkle", "wi-stars", "wi-storm-showers",];

  int _focusIndex = 0;

  @override
  Widget build(BuildContext context) {
    String iconPath = context.read<ThemeManager>().isDark
        ? "assets/images/weather_icons/light/"
        : "assets/images/weather_icons/dark/";
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 20),
        child: Row(
          children: [
            const Spacer(),
            SizedBox(
              height: 32,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _icons.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 16, // Width of the separator
                    );
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _focusIndex = index;
                        });
                      },
                      child: Image.asset("$iconPath${_icons[index]}.png",
                              filterQuality: FilterQuality.none)
                          .animate(target: _focusIndex == index ? 1 : 0)
                          .fade(begin: 0.3, end: 1.0)
                          .scaleXY(
                              end: 1.5,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInCubic),
                    );
                  }),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
