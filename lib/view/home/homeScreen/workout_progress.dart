import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/values/chart_styles.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutProgress extends StatefulWidget {
  const WorkoutProgress({super.key, required this.media});
  final Size media;
  @override
  State<WorkoutProgress> createState() => _WorkoutProgressState();
}

class _WorkoutProgressState extends State<WorkoutProgress> {
  Textarr textarr = Textarr();
  ChartStyles chartStyles = ChartStyles();
  late ChartData chartData;
   @override
  void initState() {
    super.initState();
    chartData = ChartData(ChartStyles()); // Pass your ChartStyles instance
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final lineBarsData = chartData.getLineBarsData();
    final tooltipsOnBar = chartData.getTooltipsOnBar();
    return Container(
        padding: const EdgeInsets.only(left: 15),
        height: media.width * 0.5,
        width: double.maxFinite,
        child: LineChart(
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
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                if (response == null || response.lineBarSpots == null) {
                  return;
                }
                if (event is FlTapUpEvent) {
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
                      color: Colors.transparent,
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
            lineBarsData: chartStyles.lineBarsData1,
            minY: -0.5,
            maxY: 110,
            titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(),
                topTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: chartStyles.bottomTitles,
                ),
                rightTitles: AxisTitles(
                  sideTitles: chartStyles.rightTitles,
                )),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 25,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: TColor.gray.withOpacity(0.15),
                  strokeWidth: 2,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
          ),
        ));
  }
}
