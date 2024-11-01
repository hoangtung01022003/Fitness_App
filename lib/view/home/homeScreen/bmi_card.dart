import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Đảm bảo bạn đã import thư viện fl_chart/ Thay thế bằng đường dẫn đến TColor

class BmiCard extends StatelessWidget {
  final Size media; // Tham số media để sử dụng trong widget

  const BmiCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(media.width * 0.075),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/bg_dots.png",
            height: media.width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BMI (Body Mass Index)",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "You have a normal weight",
                      style: TextStyle(
                        color: TColor.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    SizedBox(
                      width: 120,
                      height: 35,
                      child: RoundButton(
                        title: "View More",
                        type: RoundButtonType.bgSGradient,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainTabView(initialIndex: 3),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: FutureBuilder<double?>(
                    future: SharedPrefService.calculateBMIFromCache(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      double bmiValue = snapshot.data ?? 0;

                      return PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {},
                          ),
                          startDegreeOffset: 250,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 1,
                          centerSpaceRadius: 5, // Để trống phần giữa nếu cần
                          sections: showingSections(bmiValue),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Đảm bảo bạn có hàm showingSections() bên trong class này hoặc truyền nó từ bên ngoài
  List<PieChartSectionData> showingSections(double? bmiValue) {
    Color bmiColor;
    String bmiStatus;
    Color textColor;

    if (bmiValue == null || bmiValue <= 0) {
      bmiColor = Colors.grey;
      bmiStatus = 'No data'; // No data available
      textColor = Colors.black; // Màu chữ tối cho không có dữ liệu
    } else if (bmiValue < 18.5) {
      bmiColor = Colors.blue;
      bmiStatus = 'Underweight';
      textColor = Colors.white; // Màu chữ sáng cho màu nền xanh
    } else if (bmiValue < 25) {
      bmiColor = Colors.green;
      bmiStatus = 'Normal weight';
      textColor = Colors.white; // Màu chữ sáng cho màu nền xanh lá
    } else if (bmiValue < 30) {
      bmiColor = Colors.yellow;
      bmiStatus = 'Overweight';
      textColor = Colors.black; // Màu chữ tối cho màu nền vàng
    } else {
      bmiColor = Colors.red;
      bmiStatus = 'Obesity';
      textColor = Colors.white; // Màu chữ sáng cho màu nền đỏ
    }

    double bmiPercentage = (bmiValue ?? 0) / 40 * 100;

    return [
      PieChartSectionData(
        color: bmiColor,
        value: bmiPercentage,
        title: '',
        radius: 55,
        titlePositionPercentageOffset: 0.55,
        badgeWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bmiValue != null ? bmiValue.toStringAsFixed(1) : 'No data',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bmiStatus, // Hiển thị trạng thái sức khỏe
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      PieChartSectionData(
        color: Colors.grey[300],
        value: 100 - bmiPercentage,
        title: '',
        radius: 45,
        titlePositionPercentageOffset: 0.55,
      ),
    ];
  }
}
