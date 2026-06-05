import 'package:flutter/material.dart';

enum RecurrenceType {
  none,
  yearly,
  monthly;

  static RecurrenceType fromJson(Object? value) {
    if (value is! String) return RecurrenceType.none;
    for (final type in RecurrenceType.values) {
      if (type.name == value) return type;
    }
    return RecurrenceType.none;
  }
}

enum EventKind {
  normal,
  supporter;

  static EventKind fromJson(Object? value) {
    if (value is! String) return EventKind.normal;
    for (final kind in EventKind.values) {
      if (kind.name == value) return kind;
    }
    return EventKind.normal;
  }
}

class EventModel {
  final String id;
  final String name;
  final DateTime targetDate;
  final String emoji;
  final Color color;
  final DateTime createdAt;
  final RecurrenceType recurrenceType;
  final EventKind kind;
  final int supportCount;

  const EventModel({
    required this.id,
    required this.name,
    required this.targetDate,
    required this.emoji,
    required this.color,
    required this.createdAt,
    this.recurrenceType = RecurrenceType.none,
    this.kind = EventKind.normal,
    this.supportCount = 0,
  });

  bool get isSupporterReward => kind == EventKind.supporter;

  bool get isPast =>
      recurrenceType == RecurrenceType.none &&
      targetDate.isBefore(DateTime.now());

  EventModel copyWith({
    String? id,
    String? name,
    DateTime? targetDate,
    String? emoji,
    Color? color,
    DateTime? createdAt,
    RecurrenceType? recurrenceType,
    EventKind? kind,
    int? supportCount,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDate: targetDate ?? this.targetDate,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      kind: kind ?? this.kind,
      supportCount: supportCount ?? this.supportCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'targetDate': targetDate.toIso8601String(),
        'emoji': emoji,
        'color': color.toARGB32(),
        'createdAt': createdAt.toIso8601String(),
        'recurrenceType': recurrenceType.name,
        'kind': kind.name,
        'supportCount': supportCount,
      };

  factory EventModel.fromJson(Map<String, dynamic> j) => EventModel(
        id: j['id'] as String,
        name: j['name'] as String,
        targetDate: DateTime.parse(j['targetDate'] as String),
        emoji: j['emoji'] as String,
        color: Color(j['color'] as int),
        createdAt: DateTime.parse(j['createdAt'] as String),
        recurrenceType: RecurrenceType.fromJson(j['recurrenceType']),
        kind: EventKind.fromJson(j['kind']),
        supportCount: _intFromJson(j['supportCount']),
      );

  static int _intFromJson(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
