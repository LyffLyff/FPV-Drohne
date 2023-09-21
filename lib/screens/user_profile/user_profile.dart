import 'package:drone_2_0/data/providers/user_provider.dart';
import 'package:drone_2_0/screens/user_profile/user_profile_options.dart';
import 'package:drone_2_0/service/storage_service.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../themes/theme_constants.dart';
import '../../widgets/network_image.dart';
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
                      StorageService()
                          .uploadFile("test_images", path!, filename)
                          .then((value) => print(
                              "File Uploaded")); // print Message when done
                      print(path);
                    }
                  } on PlatformException catch (error) {
                    // Permission denied by user most likely
                    Logger().e(error);
                  }
                },
                child: Hero(
                    tag: "profile_image",
                    child: loadNetworkImage(
                        "assets/loading/double_ring_200px.gif",
                        "https://source.unsplash.com/600x600/?otter",
                        "assets/loading/double_ring_200px.gif")),
              ),
              Container(
                margin: const EdgeInsets.all(Margins.stdMargin),
                child: Text(
                  Provider.of<UserProvider>(context).name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            "Email: ${Provider.of<UserProvider>(context).email}",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            "Username: ${Provider.of<UserProvider>(context).username}",
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
