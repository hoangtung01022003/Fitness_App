import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/values/chart_styles.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:flutter/material.dart';

class WaterIntake extends StatefulWidget {
  const WaterIntake({super.key, required this.media});
  final Size media;
  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  Textarr textarr = Textarr();
  ChartStyles chartStyles = ChartStyles();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Water Intake",
          style: TextStyle(
              color: TColor.black, fontSize: 12, fontWeight: FontWeight.w700),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)
                .createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
          },
          child: Text(
            "4 Liters",
            style: TextStyle(
                color: TColor.white.withOpacity(0.7),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Real time updates",
          style: TextStyle(
            color: TColor.gray,
            fontSize: 12,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textarr.waterArr.map((wObj) {
            var isLast = wObj == textarr.waterArr.last;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: TColor.secondaryColor1.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    if (!isLast)
                      DottedDashedLine(
                          height: media.width * 0.078,
                          width: 0,
                          dashColor: TColor.secondaryColor1.withOpacity(0.5),
                          axis: Axis.vertical)
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wObj["title"].toString(),
                      style: TextStyle(
                        color: TColor.gray,
                        fontSize: 10,
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) {
                        return LinearGradient(
                                colors: TColor.secondaryG,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)
                            .createShader(Rect.fromLTRB(
                                0, 0, bounds.width, bounds.height));
                      },
                      child: Text(
                        wObj["subtitle"].toString(),
                        style: TextStyle(
                            color: TColor.white.withOpacity(0.7), fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            );
          }).toList(),
        )
      ],
    ));
  }
}
