import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common_widget/values/chart_styles.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:fitness/common_widget/workout_row.dart';
import 'package:fitness/view/home/homeScreen/activity_status/calories.dart';
import 'package:fitness/view/home/homeScreen/activity_status/heart_rate.dart';
import 'package:fitness/view/home/homeScreen/activity_status/sleep.dart';
import 'package:fitness/view/home/homeScreen/activity_status/water_intake.dart';
import 'package:fitness/view/home/homeScreen/bmi_card.dart';
import 'package:fitness/view/home/homeScreen/latest_workout.dart';
import 'package:fitness/view/home/homeScreen/today_target_check.dart';
import 'package:fitness/view/home/homeScreen/workout_progress.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../common/colo_extension.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Textarr textarr = Textarr();
  ChartStyles chartStyles = ChartStyles();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Nếu profile đã được tạo, tiếp tục vào trang chủ
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        padding: const EdgeInsets.only(top: 40), 
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(color: TColor.gray, fontSize: 12),
                          ),
                          Text(
                            "Stefani Wong",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationView(),
                              ),
                            );
                          },
                          icon: Image.asset(
                            "assets/img/notification_active.png",
                            width: 25,
                            height: 25,
                            fit: BoxFit.fitHeight,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  BmiCard(media: media),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  const TodayTargetCheck(),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    "Activity Status",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  HeartRate(media: media, initialHeartRate: 78),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: media.width * 1.02,
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Row(
                            children: [
                              SimpleAnimationProgressBar(
                                height: media.width * 0.85,
                                width: media.width * 0.07,
                                backgroundColor: Colors.grey.shade100,
                                foregrondColor: Colors.purple,
                                ratio: 0.5,
                                direction: Axis.vertical,
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(seconds: 3),
                                borderRadius: BorderRadius.circular(15),
                                gradientColor: LinearGradient(
                                    colors: TColor.primaryG,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              WaterIntake(media: media)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: media.width * 0.05
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Sleep(media: media),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Calories(media: media),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Workout Progress",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: ["Weekly", "Monthly"]
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {},
                              icon: Icon(Icons.expand_more, color: TColor.white),
                              hint: Text(
                                "Weekly",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: TColor.white, fontSize: 12),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  WorkoutProgress(media: media),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  LatestWorkout(textarr: textarr),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//         },
//     );
//   }
// }
