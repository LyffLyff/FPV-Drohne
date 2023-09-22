import 'package:flutter/material.dart';

Widget loadNetworkImage(String placeHolderAssetPath, String networkImageURL, String errorImageAsset) {
  return FadeInImage(
    placeholder: AssetImage(placeHolderAssetPath),
    image: NetworkImage(networkImageURL),
    imageErrorBuilder: (context, error, stackTrace) {
      return Image(
          image: AssetImage(errorImageAsset));
    },
    fit: BoxFit.fitWidth,
  );
}

Widget loadUserProfileImage(String placeHolderAssetPath, String profileImgURL, String errorImageURL) {
  return FadeInImage(
    placeholder: AssetImage(placeHolderAssetPath),
    image: NetworkImage(profileImgURL),
    imageErrorBuilder: (context, error, stackTrace) {
      return Image(
          image: NetworkImage(errorImageURL));
    },
    fit: BoxFit.fitWidth, // You can adjust the fit as needed
  );
}
