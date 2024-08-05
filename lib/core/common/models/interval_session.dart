import 'package:equatable/equatable.dart';

/// Represents an interval session.
///
/// An interval session is a session that has a main time, work time, and rest
/// time. The main time is the total time of the session, the work time is the
/// time spent working, and the rest time is the time spent resting. The session
/// can also have a title, description, and whether to prioritize overlap or
/// not.
class IntervalSession extends Equatable {
  /// Creates a new [IntervalSession] instance.
  ///
  /// [mainTime], [workTime], and [restTime] are in microseconds, and this is
  /// because they are originally collected from the [Duration] class. If we
  /// want to get all the values of a given a duration then we have to
  /// account for even the microseconds, given that we let them pick all the
  /// values from day to microseconds.
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

  IntervalSession.empty()
      : this(
          id: -1,
          title: 'Test String',
          prioritizeOverlap: false,
          mainTime: 0,
          workTime: 0,
          restTime: 0,
          createdAt: DateTime.now(),
        );

  factory IntervalSession.fromMap(Map<String, dynamic> map) {
    return IntervalSession(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      description: map['description'] as String?,
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

  /// The unique identifier for this session.
  final int id;

  /// The title of the session.
  final String title;

  /// The description of the session.
  final String? description;

  /// The main time of the session. In microseconds.
  final int mainTime;

  /// The work time of the session. In microseconds.
  final int workTime;

  /// The rest time of the session. In microseconds.
  final int restTime;

  /// Whether to prioritize overlap or not.
  final bool prioritizeOverlap;

  /// The date and time this session was created.
  final DateTime createdAt;

  /// The date and time this session was last updated.
  final DateTime? lastUpdatedAt;

  /// Whether the session has rest time or not.
  bool get hasRestTime => restTime > 0;

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
