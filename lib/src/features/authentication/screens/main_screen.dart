import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen_pages/home_screen.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen_pages/menu_screen.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen_pages/reminders_screen.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen_pages/tools_screen.dart';
import 'package:time_capsule/src/features/authentication/screens/menu_pages/albums_page.dart';
import 'package:time_capsule/src/utils/widgets/future_development.dart';
import '../../../utils/widgets/appbar_widget.dart';
import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'floating_navigation_pages/add_memory_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const ToolScreen(),
    const ReminderScreen(),
    const MenuScreen(),
  ];

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionBubble(
        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPressed: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.blue,

        // Floating Action button Icon
        iconData: Icons.add,
        backgroundColor: Colors.white,
        // Menu items
        items: <Widget>[
          // Floating action menu item
          BubbleMenu(
            title: "New Group",
            iconColor: Colors.white,
            bubbleColor: Colors.orange,
            icon: Icons.group_add,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            onPressed: () {
              Get.to(() => const ToBeDevelopedScreen());
              _animationController.reverse();
            },
          ),
          // Floating action menu item
          BubbleMenu(
            title: "View Photos",
            iconColor: Colors.white,
            bubbleColor: Colors.orange,
            icon: Icons.photo,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            onPressed: () {
              Get.to(() => const AlbumPage());
              _animationController.reverse();
            },
          ),
          //Floating action menu item
          BubbleMenu(
            title: "Add Memory",
            iconColor: Colors.white,
            bubbleColor: Colors.orange,
            icon: FontAwesomeIcons.heartCirclePlus,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            onPressed: () {
              Get.to(() => const SaveMemoryScreen());

              _animationController.reverse();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeScreen();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Colors.orange : Colors.grey,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: currentTab == 0
                                  ? Colors.orange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const ToolScreen();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.build,
                          color: currentTab == 1 ? Colors.orange : Colors.grey,
                        ),
                        Text(
                          "Tools",
                          style: TextStyle(
                              color: currentTab == 1
                                  ? Colors.orange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const ReminderScreen();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assistant,
                          color: currentTab == 2 ? Colors.orange : Colors.grey,
                        ),
                        Text(
                          "Digi Assist",
                          style: TextStyle(
                              color: currentTab == 2
                                  ? Colors.orange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const MenuScreen();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          color: currentTab == 3 ? Colors.orange : Colors.grey,
                        ),
                        Text(
                          "Menu",
                          style: TextStyle(
                              color: currentTab == 3
                                  ? Colors.orange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
