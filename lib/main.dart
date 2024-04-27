import "package:challenge_tag/challenge_tag.dart";
import "package:flutter/material.dart";
import "screens/home_screen.dart";
import "package:hive_flutter/hive_flutter.dart";

// todo: update mood colors presentation
// todo: add clear button
// todo: implement clicking a day to add/update/remove a mood

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Meal Generator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Hermit",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
      ),
      home: const Stack(
        children: [
          HomeScreen(),
          Opacity(
            opacity: 0.6,
            child: ChallengeTag(
              size: 10.0,
              radius: 2.0,
              axis: TagAxis.right,
              alignment: Alignment.topRight,
              font: "Hermit",
            ),
          ),
        ],
      ),
    );
  }
}
