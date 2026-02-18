import 'package:flutter/material.dart';
import 'package:graville_operations/screens/material/sections/material_info_section.dart';
import 'package:graville_operations/screens/material/sections/material_photo_section.dart';

class ReceiveMaterialScreen extends StatelessWidget {
  const ReceiveMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                Icon(Icons.inventory, size: 22),
                SizedBox(width: 8),
                Text(
                  "Receive Material",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                MaterialPhotoSection(),
                MaterialInfoSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
