const String tableMemo = 'Memos';

class MemoFields {
  static final List<String> values = [
    id,
    isDone,
    type,
    title,
    time,
    description,
    lastUpdated
  ];

  static const String id = '_id';
  static const String isDone = 'isDone';
  static const String type = 'type';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
  static const String lastUpdated = 'lastUpdated';
}

class Memo {
  final int? id;
  final bool isDone;
  final String type;
  final String? desprecation;
  final String title;
  final DateTime createdTime;
  final DateTime? lastUpdated;

  const Memo({
    this.id,
    required this.isDone,
    required this.type,
    this.desprecation,
    required this.title,
    required this.createdTime,
    this.lastUpdated,
  });

  Memo copy({
    int? id,
    bool? isDone,
    String? type,
    String? desprecation,
    String? title,
    DateTime? createdTime,
    DateTime? lastUpdated,
  }) =>
      Memo(
        id: id ?? this.id,
        isDone: isDone ?? this.isDone,
        type: type ?? this.type,
        title: title ?? this.title,
        desprecation: desprecation ?? this.desprecation,
        createdTime: createdTime ?? this.createdTime,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  static Memo fromJson(Map<String, Object?> json) => Memo(
        id: json[MemoFields.id] as int?,
        isDone: json[MemoFields.isDone] == 1,
        type: json[MemoFields.type] as String,
        title: json[MemoFields.title] as String,
        desprecation: json[MemoFields.description] as String,
        createdTime: DateTime.parse(json[MemoFields.time] as String),
        lastUpdated: json[MemoFields.lastUpdated] == null
            ? null
            : DateTime.parse(json[MemoFields.lastUpdated] as String),
      );

  Map<String, Object?> toJson() => {
        MemoFields.id: id,
        MemoFields.type: type,
        MemoFields.title: title,
        MemoFields.isDone: isDone ? 1 : 0,
        MemoFields.description: desprecation,
        MemoFields.time: createdTime.toIso8601String(),
        MemoFields.lastUpdated:
            lastUpdated?.toIso8601String(),
      };
}
