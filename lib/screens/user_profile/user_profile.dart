import 'package:cached_network_image/cached_network_image.dart';
import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/screens/user_profile/user_profile_options.dart';
import 'package:drone_2_0/service/storage_service.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  try {
                    Logger().i(
                      Provider.of<AuthProvider>(context, listen: false)
                          .getUser
                          ?.photoURL,
                    );
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                    );
                    if (results == null) {
                      // no file selected by user
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Why no file??")));
                    } else {
                      final path = results.files.single.path;
                      final filename = results.files.single.name;
                      const folder = "test_images";
                      await StorageService()
                          .uploadFile(folder, path!, filename);
                      final storageURL = context.read<AuthProvider>().getUser?.photoURL;
                      /*if (storageURL != null) {
                        await StorageService().deleteFile(storageURL);
                        Logger().i("Deleted Old Profile Image");
                      }*/
                      Provider.of<AuthProvider>(context, listen: false)
                          .setProfileImageURL("$folder/$filename");
                      print(path);
                    }
                  } on PlatformException catch (error) {
                    // Permission denied by user most likely
                    Logger().e(error);
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: "profile_image",
                    child: CachedNetworkImage(
                      imageUrl: Provider.of<AuthProvider>(context)
                          .getProfileImageDownloadURL,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(Margins.stdMargin),
                child: Text(
                  Provider.of<AuthProvider>(context).username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            "Email: ${Provider.of<AuthProvider>(context).email}",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            "Username: ${Provider.of<AuthProvider>(context).username}",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          addVerticalSpace(),
          ElevatedButton(
            child: const Text("Edit Userdata"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserProfileOptions()));
            },
          )
        ]),
      ),
    );
  }
}
