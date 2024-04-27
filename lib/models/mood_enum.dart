import "package:flutter/material.dart";

enum Mood {
  angry(color: Colors.red),
  happy(color: Colors.amber),
  productive(color: Colors.orange),
  sad(color: Colors.blue),
  nervous(color: Colors.purple),
  sick(color: Colors.green),
  tired(color: Colors.brown),
  neutral(color: Colors.grey);

  final Color color;
  const Mood({required this.color});
}

extension StringX on String {
  Mood get mood => Mood.values.firstWhere((m) => m.name == this);
}

extension Intx on int {
  String get monthName => switch (this) {
        1 => "January",
        2 => "February",
        3 => "March",
        4 => "April",
        5 => "May",
        6 => "June",
        7 => "July",
        8 => "August",
        9 => "September",
        10 => "October",
        11 => "November",
        12 => "December",
        _ => "",
      };

  int get toDays => switch (this) {
        == DateTime.january => 31,
        == DateTime.february =>
          (DateTime.now().year % 4 == 0 && DateTime.now().year % 100 != 0) ||
                  (DateTime.now().year % 400 == 0)
              ? 29
              : 28,
        == DateTime.march => 31,
        == DateTime.april => 30,
        == DateTime.may => 31,
        == DateTime.june => 30,
        == DateTime.july => 31,
        == DateTime.august => 31,
        == DateTime.september => 30,
        == DateTime.october => 31,
        == DateTime.november => 30,
        == DateTime.december => 31,
        _ => 0,
      };
}

extension Iterables<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
