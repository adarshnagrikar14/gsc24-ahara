import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:garbh/data/exercise_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Color redColor = const Color.fromARGB(255, 249, 76, 102);

  List<Map<String, List<String>>> exerciseData = exerciseDatas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercise",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: redColor,
        toolbarHeight: 60.0,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: exerciseData.length,
        itemBuilder: (context, index) {
          var exercise = exerciseData[index].values.first;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Text(
                    "Click to Start with ${exercise[0]}.",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ExerciseCard(
                  title: exercise[0],
                  benifits: exercise[2],
                  imageUrl: exercise[5],
                  duration: int.parse(exercise[4]),
                  exerciseDatas: exercise,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String benifits;
  final String imageUrl;
  final int duration;
  final List<String> exerciseDatas;

  const ExerciseCard({
    Key? key,
    required this.title,
    required this.benifits,
    required this.imageUrl,
    required this.duration,
    required this.exerciseDatas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerformExercise(
                exerciseData: exerciseDatas,
              ),
            ),
          );
        },
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      benifits,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Duration: $duration seconds',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerformExercise extends StatefulWidget {
  final List<String> exerciseData;
  const PerformExercise({
    super.key,
    required this.exerciseData,
  });

  @override
  State<PerformExercise> createState() => _PerformExerciseState();
}

class _PerformExerciseState extends State<PerformExercise> {
  Color redColor = const Color.fromARGB(255, 249, 76, 102);
  late int duration;
  late int currentSeconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    duration = int.parse(widget.exerciseData[4]);
    currentSeconds = duration;
  }

  void startExercise() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentSeconds > 0) {
          currentSeconds -= 1;
        } else {
          timer.cancel();
          showCompletionDialog();
        }
      });
    });
  }

  void showCompletionDialog() {
    saveData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exercise Completed"),
          content: const Text("Great job! You have completed the exercise."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.exerciseData[0];
    String description = widget.exerciseData[1];
    String benefits = widget.exerciseData[2];
    String caloriesBurn = widget.exerciseData[3];
    String imageUrl = widget.exerciseData[5];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: redColor,
        toolbarHeight: 60.0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                description,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Benefits:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(5),
              Text(
                benefits,
                style: const TextStyle(fontSize: 15.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Calories burn:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(5),
              Text(
                caloriesBurn,
                style: const TextStyle(fontSize: 15.0),
              ),
              const Gap(20.00),
              LinearProgressIndicator(
                value: 1 - (currentSeconds / duration),
                minHeight: 12.0,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
              const Gap(12.0),
              Center(
                child: Text(
                  "$currentSeconds Seconds",
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Gap(18.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    startExercise();
                  },
                  child: const Text("Start"),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String exerciseName = widget.exerciseData[0];
    String caloriesBurned = widget.exerciseData[6];

    List<String>? exerciseHistory = prefs.getStringList("exerciseHistory");

    exerciseHistory ??= [];

    exerciseHistory.add(exerciseName);
    exerciseHistory.add(caloriesBurned);
    prefs.setStringList("exerciseHistory", exerciseHistory);
  }
}
