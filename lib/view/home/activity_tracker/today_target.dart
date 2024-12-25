// import 'package:fitness/common/colo_extension.dart';
// import 'package:fitness/common_widget/today_target_cell.dart';
// import 'package:fitness/view/home/activity_tracker/add_target.dart';
// import 'package:flutter/material.dart';

// class TodayTarget extends StatelessWidget {
//   const TodayTarget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Today Target",
//               style: TextStyle(
//                   color: TColor.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700),
//             ),
//             SizedBox(
//               width: 30,
//               height: 30,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: TColor.primaryG,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: MaterialButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AddTarget(),
//                         ),
//                       );
//                     },
//                     padding: EdgeInsets.zero,
//                     height: 30,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25)),
//                     textColor: TColor.primaryColor1,
//                     minWidth: double.maxFinite,
//                     elevation: 0,
//                     color: Colors.transparent,
//                     child: const Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: 15,
//                     )),
//               ),
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         const Row(
//           children: [
//             Expanded(
//               child: TodayTargetCell(
//                 icon: "assets/img/water.png",
//                 value: "8L",
//                 title: "Water Intake",
//               ),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Expanded(
//               child: TodayTargetCell(
//                 icon: "assets/img/foot.png",
//                 value: "2400",
//                 title: "Foot Steps",
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/home/activity_tracker/add_target.dart';
import 'package:http/http.dart' as http; // Đảm bảo import đúng thư viện http
import 'package:fitness/api/target_api_service.dart';
import 'package:fitness/config/constants.dart';
import 'package:flutter/material.dart';

class TodayTarget extends StatefulWidget {
  @override
  _TodayTargetState createState() => _TodayTargetState();
}

class _TodayTargetState extends State<TodayTarget> {
  final TargetApiService _targetApiService = TargetApiService();
  List<dynamic> targets = []; // Danh sách lưu trữ dữ liệu từ API
  bool isLoading = true; // Trạng thái tải dữ liệu
  @override
  void initState() {
    super.initState();
    _fetchTargets();
  }

  Future<void> _fetchTargets() async {
    try {
      final data = await _targetApiService.fetchTargets();
      setState(() {
        targets = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching targets: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Targets'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _targetApiService.fetchTargets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No targets found'));
          } else {
            final targets = snapshot.data!;
            return ListView.builder(
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final target = targets[index];
                final targetId = target['target_id'];
                return Card(
                    child: ListTile(
                  title: Text(target['goal_type'] ?? 'Unknown Goal'),
                  subtitle: Text(
                    'Value: ${target['target_value']} ${target['unit']}\n'
                    'Start: ${target['start_date']}\n'
                    'End: ${target['target_date']}',
                  ),
                  // Chỉnh sửa ở đây để thêm nút xoá vào Row
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: TColor.gray,
                        onPressed: () async {
                          // Gọi hàm deleteTarget và truyền vào targetId
                          try {
                            await _targetApiService.deleteTarget(
                                targetId); // Gọi API để xóa target
                            // Nếu xóa thành công, có thể cập nhật giao diện như xóa target khỏi danh sách
                            setState(() {
                              targets.removeAt(
                                  index); // Xóa target khỏi danh sách hiển thị
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Target deleted successfully')),
                            );
                          } catch (e) {
                            // Nếu có lỗi, hiển thị thông báo lỗi
                            print('Error deleting target: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error deleting target: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ));
              },
            );
          }
        },
      ),
      floatingActionButton: InkWell(
        onTap: () {
          // deleteAllImages();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTarget(),
              // date: _selectedDateAppBBar,
            ),
          );
          _fetchTargets();
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.secondaryG),
              borderRadius: BorderRadius.circular(27.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 20,
            color: TColor.white,
          ),
        ),
      ),
    );
  }
}
