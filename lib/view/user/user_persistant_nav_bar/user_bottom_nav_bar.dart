import 'package:amazon/view/user/cart/cart_screen.dart';
import 'package:amazon/view/user/home/home_screen.dart';
import 'package:amazon/view/user/menu/menu_screen.dart';
import 'package:amazon/view/user/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../utils/colors.dart';

class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({super.key});

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const HomeScreen(),
        item: ItemConfig(
          icon: const Icon(CupertinoIcons.home),
          title: "Home",
          activeForegroundColor: teal,
          inactiveForegroundColor: black,
        ),
      ),
      PersistentTabConfig(
        screen: const ProfileScreen(),
        item: ItemConfig(
          icon: const Icon(CupertinoIcons.person),
          title: "You",
          activeForegroundColor: teal,
          inactiveForegroundColor: black,
        ),
      ),
      PersistentTabConfig(
        screen: const CartScreen(),
        item: ItemConfig(
          icon: const Icon(CupertinoIcons.cart),
          title: "Cart",
          activeForegroundColor: teal,
          inactiveForegroundColor: black,
        ),
      ),
      PersistentTabConfig(
        screen: const MenuScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.menu),
          title: "Menu",
          activeForegroundColor: teal,
          inactiveForegroundColor: black,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      controller: controller,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      selectedTabPressConfig: const SelectedTabPressConfig(
        popAction: PopActionType.all,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      navBarBuilder: (navBarConfig) => Style3BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
