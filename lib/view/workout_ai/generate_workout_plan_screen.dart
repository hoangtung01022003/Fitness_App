import 'package:fitness/common_widget/values/workout_tracker/fullbody_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';

class GenerateWorkoutPlanScreen extends StatefulWidget {
  const GenerateWorkoutPlanScreen({Key? key}) : super(key: key);

  @override
  _GenerateWorkoutPlanScreenState createState() =>
      _GenerateWorkoutPlanScreenState();
}

class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen> {
  String? _selectedGoal;
  String? _selectedExperience;
  bool _isLoading = false;
  String? _rawResponse;
  Map<String, dynamic>? _workoutPlan;

  final List<String> _fitnessGoals = [
    'Lose weight',
    'Build muscle',
    'Improve cardiovascular health',
    'Increase flexibility',
    'Enhance overall fitness'
  ];

  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Workout Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select your fitness goal:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _fitnessGoals
                    .map((goal) => ChoiceChip(
                          label: Text(goal),
                          selected: _selectedGoal == goal,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGoal = selected ? goal : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Select your experience level:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _experienceLevels
                    .map((level) => ChoiceChip(
                          label: Text(level),
                          selected: _selectedExperience == level,
                          onSelected: (selected) {
                            setState(() {
                              _selectedExperience = selected ? level : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (_selectedGoal != null &&
                        _selectedExperience != null &&
                        !_isLoading)
                    ? _generateWorkoutPlan
                    : null,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Generate Workout Plan'),
              ),
              const SizedBox(height: 24),
              if (_workoutPlan != null || _rawResponse != null)
                Container(
                  height: 400, // Đảm bảo kích thước cố định cho vùng cuộn.
                  child: SingleChildScrollView(
                    child: _buildWorkoutPlanDisplay(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutPlanDisplay() {
    if (_workoutPlan != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kế Hoạch Tập Luyện Cá Nhân Hóa Của Bạn',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          ..._workoutPlan!.entries
              .map((entry) => _buildSection(entry.key, entry.value)),
        ],
      );
    } else if (_rawResponse != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phản Hồi Thô (Thông Tin Gỡ Lỗi):',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 8),
          Text(_rawResponse!),
        ],
      );
    } else {
      return const Text('Chưa có kế hoạch tập luyện nào được tạo.');
    }
  }

  Widget _buildSection(String title, dynamic content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (content is List)
              ...content.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(item.toString()),
                  ))
            else
              Text(content.toString()),
          ],
        ),
      ),
    );
  }

  Future<void> _generateWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _workoutPlan = null;
      _rawResponse = null;
    });

    final gemini = Gemini.instance;
    try {
      final response = await gemini.text(
          "Dựa vào các danh sách bài tập có sẵn dưới đây và tạo một kế hoạch tập luyện có cấu trúc cho người có mục tiêu $_selectedGoal và mức độ kinh nghiệm là: $_selectedExperience. "
          "Danh sách bài tập: \n"
          "- Bài tập khởi động: ${FullbodyWorkout().warmUpExercises.join(', ')} \n"
          "- Bài tập chính: ${FullbodyWorkout().mainWorkoutExercises.join(', ')} \n"
          "- Bài tập thư giãn: ${FullbodyWorkout().coolDownExercises.join(', ')} \n"
          "- Mẹo dinh dưỡng: ${FullbodyWorkout().nutritionTips.join(', ')} \n"
          "Kế hoạch này cần bao gồm: 1. Bài tập khởi động 2. Chương trình tập chính 3. Bài tập thư giãn 4. Mẹo dinh dưỡng. "
          "Định dạng phản hồi dưới dạng một đối tượng JSON với các khóa: warmUp, mainWorkout, coolDown, nutritionTips. "
          "Với các bài tập và mẹo dinh dưỡng, sử dụng một mảng chuỗi. "
          "Ví dụ định dạng: "
          "{"
          "  \"warmUp\": ["
          "    {"
          "      \"name\": \"Bài tập 1\","
          "      \"description\": \"Mô tả chi tiết từng bước thực hiện bài tập.\","
          "      \"duration\": \"Thời gian thực hiện\","
          "      \"notes\": \"Lưu ý quan trọng nếu có\""
          "    },"
          "    {"
          "      \"name\": \"Bài tập 2\","
          "      \"description\": \"Mô tả chi tiết từng bước thực hiện bài tập.\","
          "      \"duration\": \"Thời gian thực hiện\","
          "      \"notes\": \"Lưu ý quan trọng nếu có\""
          "    }"
          "  ],"
          "  \"mainWorkout\": ["
          "    {"
          "      \"name\": \"Bài tập 1\","
          "      \"description\": \"Mô tả chi tiết từng bước thực hiện bài tập.\","
          "      \"repsOrDuration\": \"Số lần hoặc thời gian thực hiện\","
          "      \"variations\": \"Biến thể phù hợp nếu có\""
          "    },"
          "    {"
          "      \"name\": \"Bài tập 2\","
          "      \"description\": \"Mô tả chi tiết từng bước thực hiện bài tập.\","
          "      \"repsOrDuration\": \"Số lần hoặc thời gian thực hiện\","
          "      \"variations\": \"Biến thể phù hợp nếu có\""
          "    }"
          "  ],"
          "  \"coolDown\": ["
          "    {"
          "      \"name\": \"Bài tập thư giãn 1\","
          "      \"description\": \"Hướng dẫn chi tiết từng bước thực hiện.\","
          "      \"duration\": \"Thời gian thư giãn\","
          "      \"benefits\": \"Lợi ích của bài tập này\""
          "    },"
          "    {"
          "      \"name\": \"Bài tập thư giãn 2\","
          "      \"description\": \"Hướng dẫn chi tiết từng bước thực hiện.\","
          "      \"duration\": \"Thời gian thư giãn\","
          "      \"benefits\": \"Lợi ích của bài tập này\""
          "    }"
          "  ],"
          "  \"nutritionTips\": ["
          "    {"
          "      \"tip\": \"Mẹo dinh dưỡng 1\","
          "      \"benefits\": \"Ý nghĩa hoặc lợi ích của mẹo này\""
          "    },"
          "    {"
          "      \"tip\": \"Mẹo dinh dưỡng 2\","
          "      \"benefits\": \"Ý nghĩa hoặc lợi ích của mẹo này\""
          "    }"
          "  ]"
          "}");

      if (response?.output != null) {
        print("Phản hồi thô từ Gemini:");
        print(response!.output);
        setState(() {
          _rawResponse = response.output;
          _workoutPlan = _parseWorkoutPlan(response.output!);
          _isLoading = false;
        });
      } else {
        throw Exception('Không có phản hồi từ Gemini');
      }
    } catch (e) {
      print('Lỗi khi tạo kế hoạch tập luyện: $e');
      setState(() {
        _isLoading = false;
        _workoutPlan = null;
        _rawResponse = 'Lỗi: $e';
      });
    }
  }

  Map<String, dynamic> _parseWorkoutPlan(String text) {
    // Loại bỏ định dạng markdown
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      // Thay thế dãy số vấn đề bằng chuỗi
      text = text.replaceAllMapped(
          RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
          (match) =>
              ': "${match.group(1)}-${match.group(2)}"${match.group(3)}');

      // Phân tích JSON
      Map<String, dynamic> jsonResponse = jsonDecode(text);
      return _processJsonResponse(jsonResponse);
    } catch (e) {
      print('Lỗi khi phân tích JSON: $e');
      // Nếu phân tích JSON thất bại, chuyển sang phương pháp phân tích bằng văn bản
      return _parseWorkoutPlanText(text);
    }
  }

  Map<String, dynamic> _processJsonResponse(Map<String, dynamic> jsonResponse) {
    // Xử lý từng phần của kế hoạch tập luyện
    ['warmUp', 'mainWorkout', 'coolDown', 'nutritionTips'].forEach((key) {
      if (jsonResponse[key] is List) {
        jsonResponse[key] = jsonResponse[key].map((item) {
          if (item is Map) {
            return item.entries.map((e) => "${e.key}: ${e.value}").join(', ');
          }
          return item.toString();
        }).toList();
      }
    });
    return jsonResponse;
  }

  Map<String, dynamic> _parseWorkoutPlanText(String text) {
    final Map<String, dynamic> plan = {};
    String currentSection = '';
    List<String> currentList = [];

    for (var line in text.split('\n')) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.endsWith(':')) {
        if (currentSection.isNotEmpty) {
          plan[currentSection] =
              currentList.isNotEmpty ? currentList : 'Không có chi tiết';
          currentList = [];
        }
        currentSection = line.substring(0, line.length - 1);
      } else {
        if (line.startsWith('•') || line.startsWith('-')) {
          currentList.add(line.substring(1).trim());
        } else {
          currentList.add(line);
        }
      }
    }

    if (currentSection.isNotEmpty) {
      plan[currentSection] =
          currentList.isNotEmpty ? currentList : 'Không có chi tiết';
    }

    return plan;
  }
}
