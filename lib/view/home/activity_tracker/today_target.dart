import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/today_target_cell.dart';
import 'package:flutter/material.dart';

class TodayTarget extends StatelessWidget {
  const TodayTarget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
              width: 30,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: TColor.primaryG,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    height: 30,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    textColor: TColor.primaryColor1,
                    minWidth: double.maxFinite,
                    elevation: 0,
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 15,
                    )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Row(
          children: [
            Expanded(
              child: TodayTargetCell(
                icon: "assets/img/water.png",
                value: "8L",
                title: "Water Intake",
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TodayTargetCell(
                icon: "assets/img/foot.png",
                value: "2400",
                title: "Foot Steps",
              ),
            ),
          ],
        )
      ],
    );
  }
}
