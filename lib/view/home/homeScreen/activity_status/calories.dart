import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class Calories extends StatelessWidget {
  const Calories({
    super.key,
    required this.media,
  });

  final Size media;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.45,
      padding: const EdgeInsets.symmetric(
          vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2)
          ]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Calories",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                        colors: TColor.primaryG,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)
                    .createShader(Rect.fromLTRB(
                        0, 0, bounds.width, bounds.height));
              },
              child: Text(
                "760 kCal",
                style: TextStyle(
                    color: TColor.white.withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
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
                        gradient: LinearGradient(
                            colors: TColor.primaryG),
                        borderRadius: BorderRadius.circular(
                            media.width * 0.075),
                      ),
                      child: FittedBox(
                        child: Text(
                          "230kCal\nleft",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    SimpleCircularProgressBar(
                      progressStrokeWidth: 10,
                      backStrokeWidth: 10,
                      progressColors: TColor.primaryG,
                      backColor: Colors.grey.shade100,
                      valueNotifier: ValueNotifier(50),
                      startAngle: -180,
                    ),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}
