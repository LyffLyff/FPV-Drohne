import 'package:drone_2_0/data/providers/user_model.dart';
import 'package:drone_2_0/screens/user_profile/user_profile_options.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/theme_constants.dart';
import '../../widgets/network_image.dart';

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
              Center(
                child: 
                  loadNetworkImage("assets/loading/double_ring_200px.gif", "https://source.unsplash.com/600x600/?otter", "assets/loading/double_ring_200px.gif"),
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
