import 'package:flutter/material.dart';
import '../pages/main_page.dart';
import '../pages/home_page_new.dart';

final Map<String, WidgetBuilder> routes = {
  MainPage.routeName: (context) => const MainPage(),
  "/": (context) => const HomePageNew(),
};
