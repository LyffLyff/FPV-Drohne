// ignore_for_file: use_build_context_synchronously

import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/user_profile/user_profile_options.dart';
import 'package:drone_2_0/service/storage_service.dart';
import 'package:drone_2_0/widgets/profile_image.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../themes/theme_constants.dart';
import 'package:file_picker/file_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  static String id = "UserProfile";

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<void> _selectProfileImage({required BuildContext context}) async {
    try {
      Logging.info(
        Provider.of<AuthenticationProvider>(context, listen: false)
            .currentUser
            ?.photoURL,
      );
      final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );
      if (results == null) {
        // no file selected by user
        ScaffoldMessenger.of(context).showSnackBar(
          defaultSnackbar("No File Selected", color: Colors.deepOrange),
        );
        // ignore: duplicate_ignore
      } else {
        final path = results.files.single.path;
        final filename = results.files.single.name;
        const folder = "user_profiles";
        await StorageService().uploadFile(folder, path!, filename);

        // delete old profile image from Storage
        var oldStorageURL = context.read<AuthenticationProvider>().storageUrl;
        if (oldStorageURL != "") {
          await StorageService().deleteFile(oldStorageURL);
          Logging.info("Deleted Old Profile Image");
        }

        // set new Storage URL in Auth User
        final newStorageURL = "$folder/$filename";
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .updatePhotoURL(newStorageURL);

        Logging.info("Local Image File: $path");
      }
    } on PlatformException catch (error) {
      // Permission denied by user most likely
      Logging.error(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              GestureDetector(
                onTap: () async {
                  _selectProfileImage(context: context);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).width,
                    child: Hero(
                      tag: "profile_image",
                      child: profileImage(
                          context.read<AuthenticationProvider>().storageUrl,
                          context
                              .read<AuthenticationProvider>()
                              .profileImageDownloadURL),
                    ),
                  ),
                ),
              ),
              Container(
                //color: context.canvasColor,
                height: 130,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [context.colorScheme.background, Colors.transparent],
                )),
              ),
              Container(
                margin: const EdgeInsets.all(Margins.stdMargin),
                child: Text(
                  Provider.of<AuthenticationProvider>(context).username,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: context.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const Divider(
            height: 32,
          ),
          Text(
            Provider.of<AuthenticationProvider>(context).fullName,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: context.textTheme.bodyMedium,
          ),
          Text(
            Provider.of<AuthenticationProvider>(context).email,
            style: context.textTheme.bodyMedium,
          ),
          const VerticalSpace(),
          ElevatedButton(
            child: const Text(
              "Edit Userdata",
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfileOptions(),
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
