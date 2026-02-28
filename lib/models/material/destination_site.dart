import 'package:flutter/material.dart';

class DestinationSite {
  final String id;
  final String name;
  final String? description;
  const DestinationSite({
    required this.id,
    required this.name,
    this.description,
  });
}
