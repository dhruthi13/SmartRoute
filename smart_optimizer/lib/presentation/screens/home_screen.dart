import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../core/constants/colors.dart';
import 'route_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  final TextEditingController sourceController =
      TextEditingController();

  final TextEditingController destinationController =
      TextEditingController();
  
  final TextEditingController
stopController =
    TextEditingController();

List<String> stops = [];
  
  final SpeechToText speech =
    SpeechToText();

bool isListening = false;
Future<void> startListening(
  TextEditingController controller,
) async {

  bool available =
      await speech.initialize();

  if (available) {

    setState(() {
      isListening = true;
    });

    speech.listen(

      onResult: (result) {

        setState(() {

          controller.text =
              result.recognizedWords;
        });
      },
    );
  }
}

  String selectedPreference = 'Balanced';

  final List<String> preferences = [
    'Balanced',
    'Cheapest',
    'Fastest',
    'Comfort',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 20),

              const Text(
                'Smart Commute',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Find the smartest route for your journey',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              TextField(

                controller: sourceController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  filled: true,
                  fillColor: AppColors.card,

                  hintText: 'Source',

                  hintStyle:
                      const TextStyle(
                    color: Colors.grey,
                  ),

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(18),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              IconButton(

  onPressed: () =>
    startListening(sourceController),

  icon: Icon(

    isListening
        ? Icons.mic
        : Icons.mic_none,

    color: Colors.deepPurpleAccent,
    size: 32,
  ),
),

              const SizedBox(height: 18),

              TextField(

                controller:
                    destinationController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  filled: true,
                  fillColor: AppColors.card,

                  hintText: 'Destination',

                  hintStyle:
                      const TextStyle(
                    color: Colors.grey,
                  ),

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(18),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              Align(
  alignment: Alignment.centerLeft,

  child: IconButton(

    onPressed: () =>
        startListening(
          destinationController,
        ),

    icon: Icon(

      isListening
          ? Icons.mic
          : Icons.mic_none,

      color: Colors.deepPurpleAccent,
      size: 32,
    ),
  ),
),

              const SizedBox(height: 30),

              TextField(

  controller: stopController,

  style: const TextStyle(
    color: Colors.white,
  ),

  decoration: InputDecoration(

    filled: true,

    fillColor: AppColors.card,

    hintText: 'Add Stop',

    hintStyle:
        const TextStyle(
      color: Colors.grey,
    ),

    suffixIcon: IconButton(

      icon: const Icon(
        Icons.add,
        color: Colors.deepPurpleAccent,
      ),

      onPressed: () {

        if (stopController.text
            .trim()
            .isNotEmpty) {

          setState(() {

            stops.add(
              stopController.text,
            );

            stopController.clear();
          });
        }
      },
    ),

    border: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(18),

      borderSide:
          BorderSide.none,
    ),
  ),
),

Align(
  alignment: Alignment.centerLeft,

  child: IconButton(

    onPressed: () =>
        startListening(
          stopController,
        ),

    icon: Icon(

      isListening
          ? Icons.mic
          : Icons.mic_none,

      color: Colors.deepPurpleAccent,
      size: 32,
    ),
  ),
),

const SizedBox(height: 20),

Wrap(

  spacing: 10,

  runSpacing: 10,

  children: stops.map(

    (stop) {

      return Chip(

        label: Text(stop),

        backgroundColor:
            Colors.deepPurpleAccent,

        deleteIcon:
            const Icon(Icons.close),

        onDeleted: () {

          setState(() {

            stops.remove(stop);
          });
        },
      );
    },
  ).toList(),
),

const SizedBox(height: 30),

              const Text(
                'Travel Preference',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Container(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                ),

                decoration: BoxDecoration(

                  color: AppColors.card,

                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child:
                    DropdownButtonHideUnderline(

                  child: DropdownButton<String>(

                    value: selectedPreference,

                    dropdownColor:
                        AppColors.card,

                    isExpanded: true,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),

                    items:
                        preferences.map((item) {

                      return DropdownMenuItem(

                        value: item,

                        child: Text(item),
                      );
                    }).toList(),

                    onChanged: (value) {

                      setState(() {

                        selectedPreference =
                            value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(

                width: double.infinity,
                height: 60,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        AppColors.primary,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed: () {

                    if (sourceController.text
                            .trim()
                            .isEmpty ||
                        destinationController.text
                            .trim()
                            .isEmpty) {

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(

                        const SnackBar(
                          content: Text(
                            'Please enter locations',
                          ),
                        ),
                      );

                      return;
                    }

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            RouteScreen(
  stops: stops,

                          source:
                              sourceController.text,

                          destination:
                              destinationController.text,

                          preference:
                              selectedPreference,
                        ),
                      ),
                    );
                  },

                  child: const Text(

                    'Optimize Route',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
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
}