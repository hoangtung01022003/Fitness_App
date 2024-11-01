import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:fitness/common_widget/workout_row.dart';
import 'package:fitness/view/home/finished_workout_view.dart';
import 'package:flutter/material.dart';

class LatestWorkout extends StatelessWidget {
  const LatestWorkout({
    super.key,
    required this.textarr,
  });

  final Textarr textarr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Latest Workout",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See More",
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: textarr.lastWorkoutArr.length,
              itemBuilder: (context, index) {
                var wObj =
                    textarr.lastWorkoutArr[index] as Map? ?? {};
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FinishedWorkoutView(),
                        ),
                      );
                    },
                    child: WorkoutRow(wObj: wObj));
              }),
        ],
      ),
    );
  }
}
