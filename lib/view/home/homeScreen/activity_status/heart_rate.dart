import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/values/chart_styles.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key, required this.media, required this.initialHeartRate});
  final Size media;
final int initialHeartRate;
  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  Textarr textarr = Textarr();
  ChartStyles chartStyles = ChartStyles();
  late int heartRate; // Biến để lưu nhịp tim hiện tại
   @override
  void initState() {
    super.initState();
    heartRate = widget.initialHeartRate; // Khởi tạo nhịp tim với giá trị ban đầu
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: chartStyles.showingTooltipOnSpots,
        spots: chartStyles.allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: TColor.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: media.width * 0.4,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: TColor.primaryColor2.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Rate",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                              colors: TColor.primaryG,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)
                          .createShader(
                              Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                    },
                    child: Text(
                      "$heartRate BPM",
                      style: TextStyle(
                          color: TColor.white.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            LineChart(
              LineChartData(
                showingTooltipIndicators:
                    chartStyles.showingTooltipOnSpots.map((index) {
                  return ShowingTooltipIndicators([
                    LineBarSpot(
                      tooltipsOnBar,
                      lineBarsData.indexOf(tooltipsOnBar),
                      tooltipsOnBar.spots[index],
                    ),
                  ]);
                }).toList(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (response == null || response.lineBarSpots == null) {
                      return;
                    }
                    if (event is FlTapUpEvent) {
                      // ignore: unused_local_variable
                      final spots = response.lineBarSpots!;
                      chartStyles.showingTooltipOnSpots.clear();
                      final spotIndex = response.lineBarSpots!.first.spotIndex;
                      chartStyles.showingTooltipOnSpots.clear();
                      setState(() {
                        chartStyles.showingTooltipOnSpots.add(spotIndex);
                      });
                    }
                  },
                  mouseCursorResolver:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (response == null || response.lineBarSpots == null) {
                      return SystemMouseCursors.basic;
                    }
                    return SystemMouseCursors.click;
                  },
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.red,
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: TColor.secondaryColor1,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: TColor.secondaryColor1,
                    tooltipRoundedRadius: 20,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                          "${lineBarSpot.x.toInt()} mins ago",
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: lineBarsData,
                minY: 0,
                maxY: 130,
                titlesData: FlTitlesData(
                  show: false,
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
