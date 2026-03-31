import 'package:flutter/material.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/screens/application/menu_registry.dart';

class DrawerMenuTile extends StatefulWidget {
  final MenuItem menu;
  const DrawerMenuTile({super.key, required this.menu});

  @override
  State<DrawerMenuTile> createState() => _DrawerMenuTileState();
}

class _DrawerMenuTileState extends State<DrawerMenuTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _animController.forward() : _animController.reverse();
  }

  void _onSubMenuTap(SubMenu sub) {
    // TODO: navigate using sub.link e.g Get.toNamed(sub.link!)
    debugPrint("Navigate to ${sub.link}");
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    final hasSubMenus = widget.menu.subMenus.isNotEmpty;

    return Column(
      children: [
        // Parent menu tile
        ListTile(
          leading: Icon(
            MenuRegistry.inactiveIcons[widget.menu.name] ?? Icons.widgets_outlined,
            color: Colors.blue.shade900,
          ),
          title: Text(
            widget.menu.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade900,
            ),
          ),
          trailing: hasSubMenus
              ? AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade900),
          )
              : null,
          onTap: hasSubMenus ? _toggle : () {
            // TODO: navigate to menu if it has a link
            Navigator.pop(context);
          },
        ),

        // Submenu dropdown
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: const EdgeInsets.only(left: 16, bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.blue.shade200, width: 2),
              ),
            ),
            child: Column(
              children: widget.menu.subMenus.map((sub) {
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 24, right: 16),
                  leading: Icon(
                    Icons.arrow_right,
                    size: 18,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    sub.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  onTap: () => _onSubMenuTap(sub),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
