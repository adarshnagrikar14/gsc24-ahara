// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:garbh/actual_data/meal_data.dart';
// import 'package:garbh/data/meal_data.dart';
import 'package:garbh/reusables/piechart2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietPagePregnantWomen extends StatefulWidget {
  const DietPagePregnantWomen({super.key});

  @override
  State<DietPagePregnantWomen> createState() => _DietPagePregnantWomenState();
}

class _DietPagePregnantWomenState extends State<DietPagePregnantWomen> {
  Color redColor = const Color.fromARGB(255, 249, 76, 102);

  late String title = "Breakfast";

  late int cardPosition = 0;

  List<int> currentCalories = [0, 0, 0, 0];

  List<List<String>> selectedChips = [
    [], //breakfast
    [], //lunch
    [], //snacks
    [], //dinner
  ];

  List<List<Map<String, List<String>>>> mealData = mealDatas;

  final List<String> carouselItems = ["Breakfast", "Lunch", "Snacks", "Dinner"];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    loadSavedValues();
  }

  void loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? caloriesString = prefs.getString("currentCalories");
    if (caloriesString != null) {
      List<String> caloriesList = caloriesString.split(',');
      setState(() {
        currentCalories = caloriesList.map(int.parse).toList();
      });
    }

    String? selectedChipsString = prefs.getString("selectedChips");
    if (selectedChipsString != null) {
      List<List<String>> loadedChips =
          (json.decode(selectedChipsString) as List)
              .map((item) => List<String>.from(item))
              .toList();

      if (loadedChips.length == 4) {
        setState(() {
          selectedChips = loadedChips;
        });
      } else {
        print("Unexpected structure for selectedChips. Resetting values.");
        resetValues();
      }
    }
  }

  void saveCurrentCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String caloriesString = currentCalories.join(',');
    prefs.setString("currentCalories", caloriesString);
  }

  void saveSelectedChips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String selectedChipsString = json.encode(selectedChips);
    prefs.setString("selectedChips", selectedChipsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Diet Schedule",
          style: TextStyle(
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/progress_track.png",
                        width: 90.0,
                      ),
                      const Gap(12.0),
                      Expanded(
                        child: Text(
                          "Keep track of your Diet here. Select the options you consumed under specific tabs.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const Gap(5.0),
                    ],
                  ),
                ),
              ),
              const Gap(20.0),
              Text(
                "\t$title",
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 5.0,
                  top: 7.0,
                ),
                child: Text(
                  "The required meal for the day is given after this chart.",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              const Gap(20.0),
              SizedBox(
                height: MediaQuery.of(context).size.height + 450,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      title = carouselItems[index];
                      cardPosition = index;
                    });
                  },
                  children: carouselItems.map((item) {
                    int mealOption = carouselItems.indexOf(item);
                    return buildMealCard(
                      item,
                      mealOption,
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 30.0,
                ),
                child: ElevatedButton(
                  onPressed: () => resetValues(),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Center(
                      child: Text(
                        "Clear All",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMealCard(String mealType, int mealOption) {
    List<Map<String, List<String>>> mealOptions = mealData[mealOption];

    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            const Gap(60.0),
            PieChartSample2(
              title: mealType,
              cardPosition: cardPosition,
            ),
            const Gap(20.0),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 2.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/select.png",
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                      const Gap(12.0),
                      Expanded(
                        child: Text(
                          "Select all that you consumed...",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const Gap(5.0),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(15.0),
            Text(
              "Current Calories: ${currentCalories[mealOption]} Cal.",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 18,
                right: 18.0,
                bottom: 20.0,
              ),
              child: LinearProgressIndicator(
                value: currentCalories[mealOption] / getcalories(mealType),
                minHeight: 12.0,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.pink.shade300,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                mealOptions.length,
                (index) => buildChoiceChip(mealOptions[index], mealOption),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoiceChip(Map<String, List<String>> option, int mealOption) {
    List<String> optionDetails = option.values.first;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 1.5,
        child: ChoiceChip(
          label: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            optionDetails[0],
                            height: 50.0,
                            width: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(8.0),
                        SizedBox(
                          width: 60.0,
                          child: Center(
                            child: Text(
                              optionDetails[1],
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(15.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Text(
                              optionDetails[2],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                              softWrap: true,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Text(
                              "Cal. : ${optionDetails[3]}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          selectedColor: Colors.red.shade100,
          checkmarkColor: Colors.pink.shade300,
          showCheckmark: false,
          backgroundColor: const Color.fromARGB(185, 255, 235, 238),
          selected: selectedChips[mealOption].contains(optionDetails[1]),
          side: selectedChips.isEmpty
              ? BorderSide(color: Colors.red.shade100)
              : selectedChips[mealOption].contains(optionDetails[1])
                  ? BorderSide(color: Colors.red.shade600)
                  : BorderSide(color: Colors.red.shade100),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                selectedChips[mealOption].add(optionDetails[1]);
                currentCalories[mealOption] += int.parse(optionDetails[3]);
              } else {
                selectedChips[mealOption].remove(optionDetails[1]);
                currentCalories[mealOption] -= int.parse(optionDetails[3]);
              }
            });
          },
        ),
      ),
    );
  }

  void resetValues() {
    setState(() {
      currentCalories = [0, 0, 0, 0];
      selectedChips = [[], [], [], []];
    });

    saveCurrentCalories();
    saveSelectedChips();
  }

  @override
  void dispose() {
    saveCurrentCalories();
    saveSelectedChips();
    _pageController.dispose();
    super.dispose();
  }

  num getcalories(String mealType) {
    if (mealType == "Breakfast") {
      return 400;
    } else if (mealType == "Lunch") {
      return 600;
    } else if (mealType == "Snacks") {
      return 250;
    } else {
      return 600;
    }
  }
}
