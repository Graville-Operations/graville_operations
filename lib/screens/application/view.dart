import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:graville_operations/screens/application/controller.dart';
import 'package:graville_operations/screens/application/menu_registry.dart';
import 'package:graville_operations/screens/application/widgets/app_drawer.dart';
import 'package:graville_operations/screens/application/widgets/no_access_screen.dart';

class ApplicationScreen extends GetView<ApplicationController> {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.blue.shade900;
    final Color inActiveColor = Colors.blue.shade100;

    final bottomMenus = controller.state.bottomMenus;
    final drawerMenus = controller.state.drawerMenus;

    if (bottomMenus.isEmpty) return const NoAccessScreen();

    final validMenus = bottomMenus
        .where((m) => MenuRegistry.screens.containsKey(m.name))
        .toList();

    if (validMenus.isEmpty) return const NoAccessScreen();

    final List<Widget> screens = validMenus
        .map((m) => MenuRegistry.screens[m.name]!(context))
        .toList();

    final List<BottomNavigationBarItem> bottomItems = validMenus
        .map((m) => BottomNavigationBarItem(
      icon: Icon(
        MenuRegistry.inactiveIcons[m.name] ?? Icons.circle_outlined,
        color: inActiveColor,
      ),
      activeIcon: Icon(
        MenuRegistry.activeIcons[m.name] ?? Icons.circle,
        color: activeColor,
      ),
      label: m.title,
    ))
        .toList();

    return Obx(() {
      final safeIndex =
      controller.state.currentIndex.value.clamp(0, screens.length - 1);

      return Scaffold(
        drawer: drawerMenus.isNotEmpty
            ? AppDrawer(drawerMenus: drawerMenus)
            : null,
        body: LazyIndexedStack(
          index: safeIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: safeIndex,
          items: bottomItems,
          type: BottomNavigationBarType.fixed,
          onTap: controller.changeIndex,
        ),
      );
    });
  }
}
class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<bool> _activated;

  @override
  void initState() {
    super.initState();
    _activated = List.generate(
      widget.children.length,
          (i) => i == widget.index,
    );
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_activated[widget.index]) {
      setState(() => _activated[widget.index] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: List.generate(widget.children.length, (i) {
        return _activated[i] ? widget.children[i] : const SizedBox.shrink();
      }),
    );
  }
}