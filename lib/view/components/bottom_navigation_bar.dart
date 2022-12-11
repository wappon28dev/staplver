import 'package:flutter/material.dart';

Widget bottomNavigationBar = NavigationBar(
  destinations: const <Widget>[
    NavigationDestination(
      icon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.commute),
      label: 'Commute',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.bookmark),
      icon: Icon(Icons.bookmark_border),
      label: 'Saved',
    ),
  ],
);
