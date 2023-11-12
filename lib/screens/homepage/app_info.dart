import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/utils/app_info_text.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Info"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/images/logo2.png"),
                fit: BoxFit.fitWidth,
              ),
              const VerticalSpace(),
              Text(
                "Sponsored by:",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge,
              ),
              Image(
                image: Provider.of<ThemeManager>(context).isDark ? const AssetImage("assets/images/dronetech/logo_light.png") : const AssetImage("assets/images/dronetech/logo_dark.png"),
                fit: BoxFit.fitWidth,
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: const [
                  TableRow(children: [
                    TableCell(
                      child: AppInfoText(text: "Hardware Conception + Design:"),
                    ),
                    TableCell(
                      child: AppInfoText(text: "Marcel Bieder"),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: AppInfoText(text: "Embedded Programming:"),
                    ),
                    TableCell(
                      child: AppInfoText(text: "Maximilian Lendl"),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child:
                          AppInfoText(text: "Video & Data Transfer:"),
                    ),
                    TableCell(
                      child: AppInfoText(text: "Ben Heinicke"),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child:
                          AppInfoText(text: "App\nProgramming:"),
                    ),
                    TableCell(
                      child: AppInfoText(text: "Sebastian Hinterberger"),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
