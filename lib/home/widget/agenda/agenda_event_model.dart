import 'package:flutter/material.dart';

class AgendaEventModel {
  final String id;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final Color color;

  AgendaEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    this.color = const Color(0xFF5B9BF6),
  });
}
