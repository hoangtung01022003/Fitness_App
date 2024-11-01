import 'package:fitness/common_widget/success_screens/success_screen.dart';
import 'package:flutter/material.dart';

class FinishedWorkoutView extends StatefulWidget {
  const FinishedWorkoutView({super.key});

  @override
  State<FinishedWorkoutView> createState() => _FinishedWorkoutViewState();
}

class _FinishedWorkoutViewState extends State<FinishedWorkoutView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SuccessScreen(
          text1: "Congratulations, You Have Finished Your Workout",
        ),
      ),
    );
  }
}
