import "package:fltr_m_001_mood_calendar/widgets/mood_calendar.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

import "../models/mood_day.dart";
import "../models/mood_enum.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box _box;
  final List<MoodDay> _moods = List.empty(growable: true);
  Mood _selectedMood = Mood.happy;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }

  Future<void> _init() async {
    _box = await Hive.openBox("moods");
    _getAllMoods();
  }

  void _getAllMoods() async {
    _moods.clear();
    for (dynamic map in _box.values.toList()) {
      _moods.add(MoodDay.fromMap(map: map as Map<dynamic, dynamic>));
    }
    setState(() {});
  }

  void _clearAllMoods() {
    _box.clear();
    _moods.clear();
    setState(() {});
  }

  void _saveAllMoods() {
    _box.clear();
    for (MoodDay mood in _moods) {
      _box.put(
        mood.date.toIso8601String(),
        mood.toMap(),
      );
    }
  }

  void _addMood({
    required DateTime date,
  }) async {
    if (_moods
        .where((m) => m.date == date && m.mood == _selectedMood)
        .isNotEmpty) {
      _removeMood(date: date);
      return;
    }

    if (_moods.where((m) => m.date == date).isNotEmpty) {
      _removeMood(date: date);
      _addMood(date: date);
      return;
    }

    final MoodDay moodDay = MoodDay(
      date: date,
      mood: _selectedMood,
    );

    await _box.put(
      date.toIso8601String(),
      moodDay.toMap(),
    );
    _moods.add(moodDay);
    _saveAllMoods();
    setState(() {});
  }

  void _removeMood({required DateTime date}) {
    _box.delete(date.toIso8601String());
    _moods.removeWhere((m) => m.date == date);
    _saveAllMoods();
    setState(() {});
  }

  void _selectMood({required Mood mood}) {
    setState(() {
      _selectedMood = mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: size.height * 0.2,
              width: size.width * 0.8,
              child: Wrap(
                spacing: 12.0,
                runSpacing: 16.0,
                children: [
                  ...Mood.values.map(
                    (m) => SizedBox(
                      width: size.width * 0.175,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => _selectMood(mood: m),
                            child: Container(
                              width: size.width * 0.06,
                              height: size.width * 0.06,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: m.color,
                                border: Border.all(
                                  width: _selectedMood == m ? 2.0 : 0.0,
                                  color: _selectedMood == m
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          if (size.width >= 600)
                            Text(
                              m.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _clearAllMoods,
                          child: Container(
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        if (size.width >= 600)
                          const Text(
                            "clear all moods",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: MoodCalendar(
                moods: _moods,
                onDayClicked: (year, month, day) {
                  _addMood(
                    date: DateTime(year, month, day),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
