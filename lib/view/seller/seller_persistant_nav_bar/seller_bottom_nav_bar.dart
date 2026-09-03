import 'package:amazon/view/seller/inventory/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../utils/colors.dart';
import '../monitor/monitor_screen.dart';

class SellerBottomNavBar extends StatefulWidget {
  const SellerBottomNavBar({super.key});

  @override
  State<SellerBottomNavBar> createState() => _SellerBottomNavBarState();
}

class _SellerBottomNavBarState extends State<SellerBottomNavBar> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const InventoryScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.inventory_2_outlined),
          title: "Inventory",
          activeForegroundColor: teal,
          inactiveForegroundColor: black,
        ),
      ),
      PersistentTabConfig(
        screen: const MonitorScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.bar_chart_outlined),
          title: "Monitor",
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
