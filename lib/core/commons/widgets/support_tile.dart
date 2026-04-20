import 'package:flutter/material.dart';

class SupportTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SupportTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        //const Divider(height: 0),
      ],
    );
  }
}
