class FullbodyWorkout {
  List stepArr = [
    {
      "no": "01",
      "title": "Spread Your Arms",
      "detail":
          "To make the gestures feel more relaxed, stretch your arms as you start this movement. No bending of hands."
    },
    {
      "no": "02",
      "title": "Rest at The Toe",
      "detail":
          "The basis of this movement is jumping. Now, what needs to be considered is that you have to use the tips of your feet"
    },
    {
      "no": "03",
      "title": "Adjust Foot Movement",
      "detail":
          "Jumping Jack is not just an ordinary jump. But, you also have to pay close attention to leg movements."
    },
    {
      "no": "04",
      "title": "Clapping Both Hands",
      "detail":
          "This cannot be taken lightly. You see, without realizing it, the clapping of your hands helps you to keep your rhythm while doing the Jumping Jack"
    },
  ];
  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/img/img_1.png",
          "title": "Warm Up",
          "value": "00:05",
          "calories": 20
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Jumping Jack",
          "value": "12x",
          "duration": "00:05",
          "calories": 600
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Skipping",
          "value": "15x",
          "duration": "00:05",
          "calories": 100
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Squats",
          "value": "20x",
          "duration": "00:05",
          "calories": 200
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Arm Raises",
          "value": "00:05",
          "calories": 80
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Rest and Drink",
          "value": "00:05",
          "calories": 350
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {
          "image": "assets/img/img_1.png",
          "title": "Warm Up",
          "value": "00:05",
          "calories": 20
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Jumping Jack",
          "value": "12x",
          "duration": "00:05",
          "calories": 50
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Skipping",
          "value": "15x",
          "duration": "00:05",
          "calories": 30
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Squats",
          "value": "20x",
          "duration": "00:05",
          "calories": 40
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Arm Raises",
          "value": "00:05",
          "calories": 25
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Rest and Drink",
          "value": "00:05",
          "calories": 100
        },
      ],
    }
  ];

  List latestArr = [
    {
      "image": "assets/img/Workout1.png",
      "title": "Fullbody Workout",
      "time": "Today, 03:00pm"
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Upperbody Workout",
      "time": "June 05, 02:00pm"
    },
  ];

  List whatArr = [
    {
      "image": "assets/img/what_1.png",
      "title": "Fullbody Workout",
      "exercises": "11 Exercises",
      "time": "32mins"
    },
    {
      "image": "assets/img/what_2.png",
      "title": "Lowebody Workout",
      "exercises": "12 Exercises",
      "time": "40mins"
    },
    {
      "image": "assets/img/what_3.png",
      "title": "AB Workout",
      "exercises": "14 Exercises",
      "time": "20mins"
    }
  ];

  final List<String> warmUpExercises = [
    "Jumping Jacks",
    "Arm Circles",
    "Leg Swings",
    "Torso Twists"
  ];
  final List<String> mainWorkoutExercises = [
    "Push-Ups",
    "Squats",
    "Burpees",
    "Lunges",
    "Planks"
  ];
  final List<String> coolDownExercises = [
    "Hamstring Stretch",
    "Quadriceps Stretch",
    "Calf Stretch",
    "Shoulder Stretch"
  ];
  final List<String> nutritionTips = [
    "Drink plenty of water",
    "Eat a balanced diet",
    "Include protein in every meal",
    "Avoid processed foods"
  ];
}
