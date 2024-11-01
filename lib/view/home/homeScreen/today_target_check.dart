import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/home/activity_tracker_view.dart';
import 'package:flutter/material.dart';

class TodayTargetCheck extends StatelessWidget {
  const TodayTargetCheck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today Target",
            style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 70,
            height: 25,
            child: RoundButton(
              title: "Check",
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ActivityTrackerView(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
