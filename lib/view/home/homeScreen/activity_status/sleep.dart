import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';

class Sleep extends StatelessWidget {
  const Sleep({
    super.key,
    required this.media,
  });

  final Size media;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.475,
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
              "Sleep",
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
                "8h 20m",
                style: TextStyle(
                    color: TColor.white.withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ),
            const Spacer(),
            Image.asset("assets/img/sleep_grap.png",
                width: double.maxFinite,
                fit: BoxFit.fitWidth)
          ]),
    );
  }
}

