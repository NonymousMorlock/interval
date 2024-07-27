import 'package:equatable/equatable.dart';

class IntervalSession extends Equatable {
  const IntervalSession({
    required this.id,
    required this.title,
    required this.prioritizeOverlap,
    required this.mainTime,
    required this.workTime,
    required this.restTime,
    required this.createdAt,
    this.lastUpdatedAt,
    this.description,
  });

  factory IntervalSession.fromMap(Map<String, dynamic> map) {
    return IntervalSession(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      description: map['description'] as String,
      mainTime: (map['mainTime'] as num).toInt(),
      workTime: (map['workTime'] as num).toInt(),
      restTime: (map['restTime'] as num).toInt(),
      prioritizeOverlap: map['prioritizeOverlap'] as num == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdatedAt: map['lastUpdatedAt'] == null
          ? null
          : DateTime.parse(map['lastUpdatedAt'] as String),
    );
  }

  final int id;
  final String title;
  final String? description;
  final int mainTime;
  final int workTime;
  final int restTime;
  final bool prioritizeOverlap;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'mainTime': mainTime,
      'workTime': workTime,
      'restTime': restTime,
      'prioritizeOverlap': prioritizeOverlap ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
    };
  }

  IntervalSession copyWith({
    int? id,
    String? title,
    String? description,
    int? mainTime,
    int? workTime,
    int? restTime,
    bool? prioritizeOverlap,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return IntervalSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      mainTime: mainTime ?? this.mainTime,
      workTime: workTime ?? this.workTime,
      restTime: restTime ?? this.restTime,
      prioritizeOverlap: prioritizeOverlap ?? this.prioritizeOverlap,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        mainTime,
        workTime,
        restTime,
        prioritizeOverlap,
        createdAt,
        lastUpdatedAt,
      ];
}
