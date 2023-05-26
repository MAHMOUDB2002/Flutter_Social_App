import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    required String titleText,
    removeBackButton = false}) {
  // static for all pgeges
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "SocialChat" : titleText,
      style: TextStyle(
          fontSize: isAppTitle ? 40.0 : 20.0,
          color: Colors.white,
          fontFamily: isAppTitle ? 'Signatra' : ''),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
  );
}