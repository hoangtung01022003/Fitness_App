import 'package:fitness/api/sharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final List exercises;

  const WorkoutTimerScreen({Key? key, required this.exercises})
      : super(key: key);

  @override
  _WorkoutTimerScreenState createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countDown);
  bool _isRunning = false;
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isResting = false; // Thêm biến trạng thái để theo dõi chế độ nghỉ

  @override
  void initState() {
    super.initState();
    // Thiết lập thời gian đầu tiên cho bài tập
    _setExerciseDuration();
  }

  void _finishWorkout() {
    // Kết thúc bài tập và quay lại màn hình trước
    _stopWatchTimer.onResetTimer();
    Navigator.pop(context); // Quay lại trang trước
  }

  void _setExerciseDuration() {
    if (_currentSetIndex < widget.exercises.length) {
      var currentSet = widget.exercises[_currentSetIndex];
      if (_currentExerciseIndex < currentSet['set'].length) {
        var currentExercise = currentSet['set'][_currentExerciseIndex];
        String duration =
            currentExercise['duration'] ?? currentExercise['value'];
        int seconds = _convertDurationToSeconds(duration);
        _stopWatchTimer.setPresetSecondTime(seconds);
      }
    }
  }

  int _convertDurationToSeconds(String duration) {
    if (duration.contains('x')) {
      return 0; // Nếu là số lần lặp, không cần thời gian
    }
    List<String> parts = duration.split(':');
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hoàn thành!"),
          content: const Text("Bạn đã hoàn thành tất cả các bài tập."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                Navigator.pop(context, true); // Quay lại trang trước
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  int _totalCalories = 0;

// Hàm để lưu lượng calo
  void _saveCalories(int calories) async {
    // Giả sử bạn sử dụng SharedPreferences để lưu trữ calo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalCalories += calories;
    await prefs.setInt('calories', _totalCalories);
  }

  void _completeExercise() async {
    // Lấy lượng calo của bài tập hiện tại
    int calories = widget.exercises[_currentSetIndex]['set']
            [_currentExerciseIndex]['calories'] ??
        0;

    // Ghi calo vào SharedPreferences
    await SharedPrefService.saveCalories(calories);

    // In ra tổng số calo đã lưu để kiểm tra
    SharedPrefService.getCalories().then((totalCalories) {
      print("Total calories consumed: $totalCalories"); // In ra tổng số calo
    });

    setState(() {
      _currentExerciseIndex++;

      if (_currentExerciseIndex >=
          widget.exercises[_currentSetIndex]['set'].length) {
        _currentExerciseIndex = 0;
        _currentSetIndex++;
      }

      if (_currentSetIndex < widget.exercises.length) {
        _setExerciseDuration();
      } else {
        _stopWatchTimer.onResetTimer();
        _showCompletionDialog();
      }
    });
  }

  void _startRest() {
    const restDuration = 10; // 10 giây nghỉ
    _stopWatchTimer.setPresetSecondTime(restDuration);
    _stopWatchTimer.onStartTimer();
    Future.delayed(Duration(seconds: restDuration), () {
      // Sau khi hết thời gian nghỉ, bắt đầu bài tập tiếp theo
      setState(() {
        _isResting = false;
        _setExerciseDuration();
        _stopWatchTimer.onStartTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Timer"),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hiển thị thời gian đếm ngược
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snapshot) {
                    final displayTime = StopWatchTimer.getDisplayTime(
                      snapshot.data!,
                      hours: false,
                    );
                    return Text(
                      displayTime,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Hiển thị tên bài tập
                Text(
                  'Bài tập: ${widget.exercises[_currentSetIndex]['set'][_currentExerciseIndex]['title']}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                // Kiểm tra và hiển thị value và duration
                Text(
                  'Giá trị: ${widget.exercises[_currentSetIndex]['set'][_currentExerciseIndex]['value']}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                if (widget.exercises[_currentSetIndex]['set']
                        [_currentExerciseIndex]['duration'] !=
                    null)
                  Text(
                    'Thời gian: ${widget.exercises[_currentSetIndex]['set'][_currentExerciseIndex]['duration']}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                if (_isResting)
                  const Text(
                    'Thời gian nghỉ',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                const SizedBox(height: 40),

                // Nút bắt đầu hoặc tạm dừng bài tập
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRunning = !_isRunning;
                    });
                    if (_isRunning) {
                      _stopWatchTimer.onStartTimer();

                      // Đặt thời gian chờ cho bài tập hiện tại
                      Future.delayed(
                        Duration(
                            seconds: _stopWatchTimer
                                .rawTime.value), // Thời gian hiện tại
                        () {
                          // Hoàn thành bài tập và lưu calo
                          _completeExercise(); // Gọi hàm hoàn thành bài tập
                        },
                      );
                    } else {
                      _stopWatchTimer.onStopTimer();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(_isRunning ? "Stop" : "Start"),
                ),

                const SizedBox(height: 20),

                // Nút kết thúc bài tập
                ElevatedButton(
                  onPressed: _finishWorkout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kết thúc',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
