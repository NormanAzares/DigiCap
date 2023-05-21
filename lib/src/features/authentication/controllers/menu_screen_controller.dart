import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../screens/menu_pages/albums_page.dart';
import '../screens/menu_pages/memories_page.dart';
import '../screens/menu_pages/newsfeed_page.dart';
import 'authentication_controller.dart';

class MenusController extends GetxController {
  static MenusController get instance => Get.find();
  final List<ListItem> menuItems = [
    ListItem(
      icon: Icons.rss_feed,
      title: "News Feed",
      description: 'Browse latest activity',
      iconBackgroundColor: const Color.fromARGB(255, 0, 26, 71),
      iconColor: Colors.white,
      titleColor: Colors.orange,
      descriptionColor: Colors.black.withOpacity(0.3),
      iconBorderRadius: BorderRadius.circular(10),
      page: NewsFeedPage(),
      onTap: () {
        Get.to(() => NewsFeedPage());
        debugPrint("NewsPageTapped!");
      },
    ),
    ListItem(
      icon: Icons.memory,
      title: 'Manage Memories',
      description: 'View all of your Memories on DigiCap',
      iconBackgroundColor: Colors.blue,
      iconColor: Colors.white,
      titleColor: Colors.orange,
      descriptionColor: Colors.black.withOpacity(0.3),
      iconBorderRadius: BorderRadius.circular(10),
      page: MemoriesPage(),
      onTap: () {
        Get.to(() => MemoriesPage());
        debugPrint("ManageMemoriesTapped!");
      },
    ),
    ListItem(
      icon: Icons.album,
      title: 'Album',
      description: 'Explore photo albums',
      iconBackgroundColor: Colors.orange,
      iconColor: Colors.white,
      titleColor: Colors.orange,
      descriptionColor: Colors.black.withOpacity(0.3),
      iconBorderRadius: BorderRadius.circular(10),
      page: AlbumPage(),
      onTap: () {
        Get.to(() => AlbumPage());
        debugPrint("AlbumPageTapped!");
      },
    ),
    ListItem(
      icon: Icons.logout,
      title: 'Logout',
      description: 'Logout from DigiCap',
      iconBackgroundColor: Color.fromARGB(255, 226, 185, 0),
      iconColor: Colors.white,
      titleColor: Colors.orange,
      descriptionColor: Colors.black.withOpacity(0.3),
      iconBorderRadius: BorderRadius.circular(10),
      page: null,
      onTap: () {
        AuthController.instance.logout();
        AuthController.instance.email.text = "";
        AuthController.instance.password.text = "";
      },
    ),
  ];
}

class ListItem {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBackgroundColor;
  final BorderRadius iconBorderRadius;
  final Color titleColor;
  final Color descriptionColor;
  final Function onTap;
  final Widget? page;

  ListItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.iconBorderRadius,
    required this.titleColor,
    required this.descriptionColor,
    required this.page,
    required this.onTap,
  });
}