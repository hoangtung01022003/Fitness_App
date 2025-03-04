import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calories extends StatelessWidget {
  Calories({
    super.key,
    required this.media,
  });

  final Size media;
  ValueNotifier<double> progressPercentageNotifier = ValueNotifier(0);

  get fullcalor => 500;
  Future<int> _getSavedCalories() async {
    // Hàm lấy tổng calorie đã lưu
    int calories = await SharedPrefService.getCalories();
    // final fullcalor = 500;
    // int remainingCalories = fullcalor - calories;
    double progressPercentage =
        ((calories / fullcalor) * 100).clamp(0, 100).toDouble();
    progressPercentageNotifier.value = progressPercentage;
    print(progressPercentageNotifier);

    return calories;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.485,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calories",
            style: TextStyle(
              color: TColor.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            child: FutureBuilder<int>(
              future: _getSavedCalories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Loading...",
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  );
                } else if (snapshot.hasData) {
                  int totalCalories = snapshot.data!;
                  return Text(
                    "$totalCalories kCal",
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  );
                } else {
                  return Text(
                    "0 kCal",
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  );
                }
              },
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: media.width * 0.2,
              height: media.width * 0.2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075),
                    ),
                    child: FutureBuilder<int>(
                      future: _getSavedCalories(),
                      builder: (context, snapshot) {
                        int remainingCalories =
                            fullcalor - (snapshot.data ?? 0);
                        return FittedBox(
                          child: Text(
                            "${remainingCalories}kCal\nleft",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SimpleCircularProgressBar(
                    progressStrokeWidth: 10,
                    backStrokeWidth: 10,
                    progressColors: TColor.primaryG,
                    backColor: Colors.grey.shade100,
                    valueNotifier: progressPercentageNotifier,
                    startAngle: -180,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
