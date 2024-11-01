import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.text1,
  });

  final String text1;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            TImages.completeWorkout,
            height: media.width * 0.8,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            text1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Exercises is king and nutrition is queen. Combine the two and you will have a kingdom",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.gray,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "-Mr.Tung",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.gray,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          RoundButton(
              title: "Back To Home",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainTabView(initialIndex: 0),
                  ),
                );
              }),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
