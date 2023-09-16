import 'package:flutter/material.dart';

Widget loadNetworkImage(String placeHolderAssetPath, String networkImageURL, String errorImageAsset) {
  return FadeInImage(
    placeholder: AssetImage(placeHolderAssetPath),
    image: NetworkImage(networkImageURL),
    imageErrorBuilder: (context, error, stackTrace) {
      return Image(
          image: AssetImage(errorImageAsset));
    },
    fit: BoxFit.cover, // You can adjust the fit as needed
  );
}
