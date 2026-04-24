import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime targetDate;
  final String emoji;
  final Color color;
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.name,
    required this.targetDate,
    required this.emoji,
    required this.color,
    required this.createdAt,
  });

  bool get isPast => targetDate.isBefore(DateTime.now());

  EventModel copyWith({
    String? id,
    String? name,
    DateTime? targetDate,
    String? emoji,
    Color? color,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDate: targetDate ?? this.targetDate,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
