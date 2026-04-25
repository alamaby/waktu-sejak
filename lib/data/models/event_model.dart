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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'targetDate': targetDate.toIso8601String(),
        'emoji': emoji,
        'color': color.toARGB32(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory EventModel.fromJson(Map<String, dynamic> j) => EventModel(
        id: j['id'] as String,
        name: j['name'] as String,
        targetDate: DateTime.parse(j['targetDate'] as String),
        emoji: j['emoji'] as String,
        color: Color(j['color'] as int),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
