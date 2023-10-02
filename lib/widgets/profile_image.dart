import 'package:cached_network_image/cached_network_image.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:flutter/material.dart';

Widget profileImage(String storagePath, String downloadUrl) {
  return storagePath != ""
      ? CachedNetworkImage(
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: circularLoadingIcon(),
          ),
          imageUrl: downloadUrl,
          fit: BoxFit.fitWidth,
        )
      : const Icon(Icons.help_outline_outlined);
}
