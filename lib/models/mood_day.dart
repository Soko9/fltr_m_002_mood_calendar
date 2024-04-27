import "mood_enum.dart";

class MoodDay {
  final DateTime date;
  final Mood mood;

  const MoodDay({
    required this.date,
    required this.mood,
  });

  Map<String, dynamic> toMap() => {
        "date": date.millisecondsSinceEpoch,
        "mood": mood.name,
      };

  factory MoodDay.fromMap({required Map<dynamic, dynamic> map}) => MoodDay(
        date: DateTime.fromMillisecondsSinceEpoch(
          map["date"] as int,
        ),
        mood: (map["mood"] as String).mood,
      );

  @override
  String toString() => "MoodDay(date: $date, mood: $mood)";
}
