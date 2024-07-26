class IntervalSession {
  IntervalSession({
    required this.id,
    required this.prioritizeOverlap,
    required this.mainTime,
    required this.workTime,
    required this.restTime,
    required this.createdAt,
    this.lastUpdatedAt,
  });

  factory IntervalSession.fromMap(Map<String, dynamic> map) {
    return IntervalSession(
      id: map['id'] as int,
      mainTime: map['mainTime'] as int,
      workTime: map['workTime'] as int,
      restTime: map['restTime'] as int,
      prioritizeOverlap: map['prioritizeOverlap'] as num == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdatedAt: map['lastUpdatedAt'] == null
          ? null
          : DateTime.parse(map['lastUpdatedAt'] as String),
    );
  }

  final int id;
  final int mainTime;
  final int workTime;
  final int restTime;
  final bool prioritizeOverlap;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
    int? mainTime,
    int? workTime,
    int? restTime,
    bool? prioritizeOverlap,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return IntervalSession(
      id: id ?? this.id,
      mainTime: mainTime ?? this.mainTime,
      workTime: workTime ?? this.workTime,
      restTime: restTime ?? this.restTime,
      prioritizeOverlap: prioritizeOverlap ?? this.prioritizeOverlap,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
