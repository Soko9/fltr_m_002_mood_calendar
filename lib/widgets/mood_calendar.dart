import "package:fltr_m_001_mood_calendar/models/mood_enum.dart";
import "package:flutter/material.dart";

import "../models/mood_day.dart";

class MoodCalendar extends StatelessWidget {
  final List<MoodDay> moods;
  final void Function(
    int year,
    int month,
    int day,
  )? onDayClicked;

  const MoodCalendar({
    super.key,
    required this.moods,
    this.onDayClicked,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return Center(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) => Wrap(
            // itemCount: today.month,
            spacing: 32.0,
            runSpacing: 64.0,
            children: List.generate(
              today.month,
              (index) => _monthBuilder(
                width: constraints.maxWidth <= 768
                    ? constraints.maxWidth * 0.85
                    : constraints.maxWidth * 0.4,
                month: index + 1,
                today: today,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthBuilder({
    required double width,
    required int month,
    required DateTime today,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month.monthName),
          const SizedBox(height: 4.0),
          SizedBox(
            width: width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              children: List.generate(
                month == today.month ? today.day : month.toDays,
                (index) => _dayBuilder(
                  month: month,
                  day: index + 1,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _dayBuilder({
    required int month,
    required int day,
  }) {
    final MoodDay? moodDay = moods
        .firstWhereOrNull((m) => m.date.month == month && m.date.day == day);

    return InkWell(
      onTap: () {
        onDayClicked!(DateTime.now().year, month, day);
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        width: 25.0,
        height: 25.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: moodDay != null ? moodDay.mood.color : Colors.black,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
