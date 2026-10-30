import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const KinetIQApp());
}

const lime = Color(0xFFB8FF3D);
const bg = Color(0xFF090B0E);
const panel = Color(0xFF111419);
const panel2 = Color(0xFF171B20);
const border = Color(0xFF252A31);

class KinetIQApp extends StatelessWidget {
  const KinetIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KinetIQ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: lime,
          brightness: Brightness.dark,
        ),
      ),
      home: const KinetIQShell(),
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================

class KinetIQShell extends StatefulWidget {
  const KinetIQShell({super.key});

  @override
  State<KinetIQShell> createState() => _KinetIQShellState();
}

class _KinetIQShellState extends State<KinetIQShell> {
  int selectedIndex = 0;

  final pages = const [
    DashboardPage(),
    WorkoutsPage(),
    NutritionPage(),
    ProgressPage(),
    SettingsPage(),
  ];

  final titles = const [
    'Dashboard',
    'Workouts',
    'Nutrition',
    'Progress',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() => selectedIndex = index);
            },
          ),
          Expanded(
            child: Column(
              children: [
                AppTopBar(title: titles[selectedIndex]),
                Expanded(
                  child: pages[selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SIDEBAR
// ============================================================

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F12),
        border: Border(
          right: BorderSide(color: border),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 35),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: lime,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: lime.withOpacity(.35),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'KINETIQ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.7,
                  ),
                ),
              ],
            ),
          ),

          navItem(0, Icons.dashboard_rounded, 'Dashboard'),
          navItem(1, Icons.fitness_center_rounded, 'Workouts'),
          navItem(2, Icons.restaurant_menu_rounded, 'Nutrition'),
          navItem(3, Icons.insights_rounded, 'Progress'),

          const Spacer(),

          navItem(4, Icons.settings_outlined, 'Settings'),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: lime.withOpacity(.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: lime.withOpacity(.45),
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: lime,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aeraf',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Athlete',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(int index, IconData icon, String title) {
    final active = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 3,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () => onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: active
                  ? lime.withOpacity(.11)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(13),
              border: active
                  ? Border.all(
                      color: lime.withOpacity(.16),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: active ? lime : Colors.white54,
                ),
                const SizedBox(width: 13),
                Text(
                  title,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.white60,
                    fontWeight:
                        active ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (active) ...[
                  const Spacer(),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: lime,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TOP BAR
// ============================================================

class AppTopBar extends StatelessWidget {
  final String title;

  const AppTopBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(color: Color(0xFF181B20)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.white70,
                ),
                SizedBox(width: 8),
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 25, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF192019),
                  Color(0xFF101510),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: lime.withOpacity(.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: lime.withOpacity(.045),
                  blurRadius: 35,
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GOOD MORNING, AERAF 👋',
                        style: TextStyle(
                          color: lime,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Ready to build\nsomething stronger?',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 13),
                      Text(
                        'Stay consistent. Track your progress. Become better.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 24),
                      GlowButton(
                        text: 'START WORKOUT',
                        icon: Icons.play_arrow_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                const GoalCircle(),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const SectionTitle(title: 'TODAY'),

          const SizedBox(height: 14),

          const Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department_rounded,
                  title: 'CALORIES',
                  value: '1,840',
                  unit: 'kcal',
                  change: '+12%',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.fitness_center_rounded,
                  title: 'WORKOUT',
                  value: '48',
                  unit: 'min',
                  change: '+8%',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.monitor_weight_outlined,
                  title: 'WEIGHT',
                  value: '69.0',
                  unit: 'kg',
                  change: '-0.4',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.water_drop_rounded,
                  title: 'WATER',
                  value: '2.1',
                  unit: 'L',
                  change: '70%',
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: DashboardCard(
                  title: "TODAY'S WORKOUT",
                  trailing: 'CHEST + TRICEPS',
                  child: Column(
                    children: const [
                      ExerciseRow(
                        number: '01',
                        exercise: 'Barbell Bench Press',
                        sets: '4 sets',
                        reps: '8–10 reps',
                      ),
                      ExerciseRow(
                        number: '02',
                        exercise: 'Incline Dumbbell Press',
                        sets: '3 sets',
                        reps: '10–12 reps',
                      ),
                      ExerciseRow(
                        number: '03',
                        exercise: 'Cable Fly',
                        sets: '3 sets',
                        reps: '12–15 reps',
                      ),
                      ExerciseRow(
                        number: '04',
                        exercise: 'Tricep Pushdown',
                        sets: '3 sets',
                        reps: '10–12 reps',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: DashboardCard(
                  title: 'NUTRITION',
                  trailing: 'TODAY',
                  child: Column(
                    children: const [
                      NutritionProgress(
                        label: 'Protein',
                        current: '118g',
                        target: '150g',
                        progress: .79,
                      ),
                      SizedBox(height: 20),
                      NutritionProgress(
                        label: 'Carbs',
                        current: '184g',
                        target: '250g',
                        progress: .74,
                      ),
                      SizedBox(height: 20),
                      NutritionProgress(
                        label: 'Calories',
                        current: '1840',
                        target: '2400',
                        progress: .77,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          DashboardCard(
            title: 'WEEKLY ACTIVITY',
            trailing: 'THIS WEEK',
            child: SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  ActivityBar(day: 'MON', value: .65),
                  ActivityBar(day: 'TUE', value: .82),
                  ActivityBar(day: 'WED', value: .48),
                  ActivityBar(day: 'THU', value: .92),
                  ActivityBar(day: 'FRI', value: .70),
                  ActivityBar(day: 'SAT', value: .55),
                  ActivityBar(day: 'SUN', value: .25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WORKOUTS PAGE
// ============================================================

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  String selected = 'Chest';

  final Map<String, List<Map<String, dynamic>>> workouts = {
    'Chest': [
      {
        'name': 'Barbell Bench Press',
        'sets': 4,
        'reps': 8,
        'weight': 60.0,
      },
      {
        'name': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': 10,
        'weight': 22.5,
      },
      {
        'name': 'Cable Fly',
        'sets': 3,
        'reps': 12,
        'weight': 15.0,
      },
    ],
    'Back': [
      {
        'name': 'Lat Pulldown',
        'sets': 4,
        'reps': 10,
        'weight': 50.0,
      },
      {
        'name': 'Barbell Row',
        'sets': 4,
        'reps': 8,
        'weight': 50.0,
      },
      {
        'name': 'Seated Cable Row',
        'sets': 3,
        'reps': 12,
        'weight': 40.0,
      },
    ],
    'Shoulders': [
      {
        'name': 'Overhead Press',
        'sets': 4,
        'reps': 8,
        'weight': 35.0,
      },
      {
        'name': 'Lateral Raises',
        'sets': 4,
        'reps': 12,
        'weight': 10.0,
      },
      {
        'name': 'Rear Delt Fly',
        'sets': 3,
        'reps': 15,
        'weight': 7.5,
      },
    ],
    'Biceps': [
      {
        'name': 'Barbell Curl',
        'sets': 4,
        'reps': 10,
        'weight': 25.0,
      },
      {
        'name': 'Hammer Curl',
        'sets': 3,
        'reps': 12,
        'weight': 12.5,
      },
      {
        'name': 'Preacher Curl',
        'sets': 3,
        'reps': 10,
        'weight': 20.0,
      },
    ],
    'Triceps': [
      {
        'name': 'Tricep Pushdown',
        'sets': 4,
        'reps': 12,
        'weight': 30.0,
      },
      {
        'name': 'Skull Crushers',
        'sets': 3,
        'reps': 10,
        'weight': 25.0,
      },
      {
        'name': 'Overhead Tricep Extension',
        'sets': 3,
        'reps': 12,
        'weight': 20.0,
      },
    ],
    'Legs': [
      {
        'name': 'Barbell Squat',
        'sets': 4,
        'reps': 8,
        'weight': 80.0,
      },
      {
        'name': 'Leg Press',
        'sets': 4,
        'reps': 10,
        'weight': 120.0,
      },
      {
        'name': 'Leg Curl',
        'sets': 3,
        'reps': 12,
        'weight': 40.0,
      },
      {
        'name': 'Calf Raises',
        'sets': 4,
        'reps': 15,
        'weight': 50.0,
      },
    ],
  };

  final Set<int> completed = {};

  List<Map<String, dynamic>> get exercises => workouts[selected]!;

  int get totalSets {
    return exercises.fold<int>(
      0,
      (sum, exercise) => sum + (exercise['sets'] as int),
    );
  }

  int get completedCount => completed.length;

  double get progress {
    if (exercises.isEmpty) return 0;
    return completed.length / exercises.length;
  }

  void _resetCompletion() {
    completed.clear();
  }

  void _selectWorkout(String workout) {
    setState(() {
      selected = workout;
      _resetCompletion();
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      if (completed.contains(index)) {
        completed.remove(index);
      } else {
        completed.add(index);
      }
    });
  }

  void _showAddExerciseDialog() {
    _showExerciseDialog();
  }

  void _showEditExerciseDialog(int index) {
    final exercise = exercises[index];

    _showExerciseDialog(
      editing: true,
      index: index,
      existingName: exercise['name'].toString(),
      existingSets: exercise['sets'].toString(),
      existingReps: exercise['reps'].toString(),
      existingWeight: exercise['weight'].toString(),
    );
  }

  void _showExerciseDialog({
    bool editing = false,
    int? index,
    String existingName = '',
    String existingSets = '3',
    String existingReps = '10',
    String existingWeight = '0',
  }) {
    final nameController = TextEditingController(text: existingName);
    final setsController = TextEditingController(text: existingSets);
    final repsController = TextEditingController(text: existingReps);
    final weightController = TextEditingController(text: existingWeight);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: border),
          ),
          title: Text(
            editing ? 'EDIT EXERCISE' : 'ADD EXERCISE',
            style: TextStyle(
              color: lime,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(
                  controller: nameController,
                  label: 'Exercise name',
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _dialogField(
                        controller: setsController,
                        label: 'Sets',
                        icon: Icons.repeat,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dialogField(
                        controller: repsController,
                        label: 'Reps',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _dialogField(
                  controller: weightController,
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lime,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final name = nameController.text.trim();

                final sets = int.tryParse(
                  setsController.text.trim(),
                );

                final reps = int.tryParse(
                  repsController.text.trim(),
                );

                final weight = double.tryParse(
                  weightController.text.trim(),
                );

                if (name.isEmpty ||
                    sets == null ||
                    reps == null ||
                    weight == null ||
                    sets <= 0 ||
                    reps <= 0 ||
                    weight < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: const Text(
                        'Please enter valid exercise details.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  final newExercise = {
                    'name': name,
                    'sets': sets,
                    'reps': reps,
                    'weight': weight,
                  };

                  if (editing && index != null) {
                    exercises[index] = newExercise;
                  } else {
                    exercises.add(newExercise);
                  }

                  _resetCompletion();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: lime,
                    content: Text(
                      editing
                          ? '$name updated successfully.'
                          : '$name added to $selected.',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                editing ? 'SAVE CHANGES' : 'ADD EXERCISE',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(.45),
        ),
        prefixIcon: Icon(
          icon,
          color: lime,
          size: 20,
        ),
        filled: true,
        fillColor: panel2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lime),
        ),
      ),
    );
  }

  void _deleteExercise(int index) {
    final exerciseName = exercises[index]['name'].toString();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: border),
          ),
          title: const Text(
            'DELETE EXERCISE?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Remove "$exerciseName" from your $selected workout?',
            style: TextStyle(
              color: Colors.white.withOpacity(.65),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  exercises.removeAt(index);
                  _resetCompletion();
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: panel2,
                    content: Text(
                      '$exerciseName deleted.',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              child: const Text(
                'DELETE',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryCard(
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: lime.withOpacity(.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: lime,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.45),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseCard(
    Map<String, dynamic> exercise,
    int index,
  ) {
    final isComplete = completed.contains(index);

    final name = exercise['name'].toString();
    final sets = exercise['sets'] as int;
    final reps = exercise['reps'] as int;
    final weight = (exercise['weight'] as num).toDouble();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isComplete
            ? lime.withOpacity(.07)
            : panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isComplete
              ? lime.withOpacity(.55)
              : border,
          width: isComplete ? 1.2 : 1,
        ),
        boxShadow: isComplete
            ? [
                BoxShadow(
                  color: lime.withOpacity(.06),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isComplete
                      ? lime
                      : panel2,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: isComplete
                      ? const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 24,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: lime,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        decoration: isComplete
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: lime,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 7,
                      children: [
                        _exerciseTag(
                          '$sets sets',
                          Icons.layers_outlined,
                        ),
                        _exerciseTag(
                          '$reps reps',
                          Icons.repeat,
                        ),
                        _exerciseTag(
                          '${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)} kg',
                          Icons.monitor_weight_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: panel2,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(.5),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditExerciseDialog(index);
                  } else if (value == 'delete') {
                    _deleteExercise(index);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditExerciseDialog(index),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 17,
                  ),
                  label: const Text('EDIT'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white.withOpacity(.75),
                    side: BorderSide(color: border),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _toggleComplete(index),
                  icon: Icon(
                    isComplete
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: Text(
                    isComplete ? 'COMPLETED' : 'MARK COMPLETE',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isComplete
                        ? lime
                        : panel2,
                    foregroundColor: isComplete
                        ? Colors.black
                        : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    side: BorderSide(
                      color: isComplete
                          ? lime
                          : border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exerciseTag(
    String text,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: panel2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: lime,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(.60),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _finishWorkout() {
    if (exercises.isEmpty) return;

    if (completed.length != exercises.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: panel2,
          content: const Text(
            'Complete all exercises before finishing the workout.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: lime.withOpacity(.4)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: lime.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_outlined,
                  color: lime,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'WORKOUT COMPLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$selected workout crushed! 🔥',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: panel2,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Text(
                      '${exercises.length} exercises • $totalSets total sets',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.75),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '100% completed',
                      style: TextStyle(
                        color: lime,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lime,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 850;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 32 : 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRAIN WITH PURPOSE.',
                          style: TextStyle(
                            color: lime,
                            fontSize: isWide ? 13 : 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'WORKOUTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Build your session. Track every rep. Get stronger.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.50),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: lime.withOpacity(.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: lime.withOpacity(.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt,
                          color: lime,
                          size: 17,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${completed.length}/${exercises.length}',
                          style: TextStyle(
                            color: lime,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // MUSCLE SPLITS
              Text(
                'MUSCLE SPLIT',
                style: TextStyle(
                  color: Colors.white.withOpacity(.45),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: workouts.keys.map((workout) {
                    final active = selected == workout;

                    return Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(workout),
                        selected: active,
                        onSelected: (_) {
                          _selectWorkout(workout);
                        },
                        backgroundColor: panel,
                        selectedColor: lime,
                        side: BorderSide(
                          color: active
                              ? lime
                              : border,
                        ),
                        labelStyle: TextStyle(
                          color: active
                              ? Colors.black
                              : Colors.white.withOpacity(.70),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // SUMMARY
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _summaryCard(
                              'Exercises',
                              '${exercises.length}',
                              Icons.fitness_center,
                            ),
                            const SizedBox(width: 10),
                            _summaryCard(
                              'Total sets',
                              '$totalSets',
                              Icons.layers_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _summaryCard(
                              'Completed',
                              '$completedCount',
                              Icons.check_circle_outline,
                            ),
                            const SizedBox(width: 10),
                            _summaryCard(
                              'Progress',
                              '${(progress * 100).round()}%',
                              Icons.trending_up,
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      _summaryCard(
                        'Exercises',
                        '${exercises.length}',
                        Icons.fitness_center,
                      ),
                      const SizedBox(width: 12),
                      _summaryCard(
                        'Total sets',
                        '$totalSets',
                        Icons.layers_outlined,
                      ),
                      const SizedBox(width: 12),
                      _summaryCard(
                        'Completed',
                        '$completedCount',
                        Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 12),
                      _summaryCard(
                        'Progress',
                        '${(progress * 100).round()}%',
                        Icons.trending_up,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // PROGRESS BAR
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'SESSION PROGRESS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(progress * 100).round()}%',
                          style: TextStyle(
                            color: lime,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: panel2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          lime,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // EXERCISES HEADER
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${exercises.length} exercises in this session',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.45),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddExerciseDialog,
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: const Text('ADD EXERCISE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // EXERCISE LIST
              if (exercises.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 45,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.white.withOpacity(.20),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'NO EXERCISES YET',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Add your first exercise to start this workout.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.40),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(
                  exercises.length,
                  (index) => _exerciseCard(
                    exercises[index],
                    index,
                  ),
                ),

              const SizedBox(height: 8),

              // FINISH BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: exercises.isNotEmpty
                      ? _finishWorkout
                      : null,
                  icon: Icon(
                    completed.length == exercises.length &&
                            exercises.isNotEmpty
                        ? Icons.emoji_events
                        : Icons.flag_outlined,
                  ),
                  label: Text(
                    completed.length == exercises.length &&
                            exercises.isNotEmpty
                        ? 'FINISH WORKOUT'
                        : 'COMPLETE ALL EXERCISES',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        completed.length == exercises.length &&
                                exercises.isNotEmpty
                            ? lime
                            : panel2,
                    foregroundColor:
                        completed.length == exercises.length &&
                                exercises.isNotEmpty
                            ? Colors.black
                            : Colors.white.withOpacity(.35),
                    disabledBackgroundColor: panel2,
                    disabledForegroundColor:
                        Colors.white.withOpacity(.25),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: completed.length == exercises.length &&
                              exercises.isNotEmpty
                          ? lime
                          : border,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// NUTRITION PAGE
// ============================================================

// ============================================================
// NUTRITION PAGE
// ============================================================

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final int calorieTarget = 2400;
  final int proteinTarget = 150;
  final int carbsTarget = 250;
  final int fatsTarget = 70;

  final List<Map<String, dynamic>> meals = [
    {
      'type': 'Breakfast',
      'name': 'Oats + Banana + Eggs',
      'calories': 520,
      'protein': 28,
      'carbs': 62,
      'fats': 18,
    },
    {
      'type': 'Lunch',
      'name': 'Chicken Rice Bowl',
      'calories': 680,
      'protein': 48,
      'carbs': 72,
      'fats': 17,
    },
    {
      'type': 'Snack',
      'name': 'Greek Yogurt + Nuts',
      'calories': 280,
      'protein': 20,
      'carbs': 24,
      'fats': 12,
    },
    {
      'type': 'Dinner',
      'name': 'Paneer Roti',
      'calories': 360,
      'protein': 22,
      'carbs': 26,
      'fats': 15,
    },
  ];

  int get calories =>
      meals.fold(0, (sum, meal) => sum + meal['calories'] as int);

  int get protein =>
      meals.fold(0, (sum, meal) => sum + meal['protein'] as int);

  int get carbs =>
      meals.fold(0, (sum, meal) => sum + meal['carbs'] as int);

  int get fats =>
      meals.fold(0, (sum, meal) => sum + meal['fats'] as int);

  double _progress(int current, int target) {
    return (current / target).clamp(0.0, 1.0);
  }

  void _showAddMealDialog() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();

    String selectedType = 'Breakfast';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: panel,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: border),
              ),
              title: Text(
                'ADD MEAL',
                style: TextStyle(
                  color: lime,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _mealField(
                      controller: nameController,
                      label: 'Meal name',
                      icon: Icons.restaurant_outlined,
                    ),
                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: selectedType,
                      dropdownColor: panel2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Meal type',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(.45),
                        ),
                        prefixIcon: Icon(
                          Icons.schedule_outlined,
                          color: lime,
                        ),
                        filled: true,
                        fillColor: panel2,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: lime),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Breakfast',
                          child: Text('Breakfast'),
                        ),
                        DropdownMenuItem(
                          value: 'Lunch',
                          child: Text('Lunch'),
                        ),
                        DropdownMenuItem(
                          value: 'Dinner',
                          child: Text('Dinner'),
                        ),
                        DropdownMenuItem(
                          value: 'Snack',
                          child: Text('Snack'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _mealField(
                            controller: caloriesController,
                            label: 'Calories',
                            icon: Icons.local_fire_department_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _mealField(
                            controller: proteinController,
                            label: 'Protein (g)',
                            icon: Icons.egg_alt_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _mealField(
                            controller: carbsController,
                            label: 'Carbs (g)',
                            icon: Icons.grain_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _mealField(
                            controller: fatsController,
                            label: 'Fats (g)',
                            icon: Icons.water_drop_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final caloriesValue =
                        int.tryParse(caloriesController.text.trim());
                    final proteinValue =
                        int.tryParse(proteinController.text.trim());
                    final carbsValue =
                        int.tryParse(carbsController.text.trim());
                    final fatsValue =
                        int.tryParse(fatsController.text.trim());

                    if (name.isEmpty ||
                        caloriesValue == null ||
                        proteinValue == null ||
                        carbsValue == null ||
                        fatsValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter valid meal details.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      meals.add({
                        'type': selectedType,
                        'name': name,
                        'calories': caloriesValue,
                        'protein': proteinValue,
                        'carbs': carbsValue,
                        'fats': fatsValue,
                      });
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: lime,
                        content: Text(
                          '$name added successfully.',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lime,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'ADD MEAL',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _mealField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(.45),
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: lime,
          size: 19,
        ),
        filled: true,
        fillColor: panel2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lime),
        ),
      ),
    );
  }

  void _deleteMeal(int index) {
    final mealName = meals[index]['name'];

    setState(() {
      meals.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: panel2,
        content: Text(
          '$mealName removed.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _macroCard({
    required String title,
    required String current,
    required String target,
    required double progress,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: lime.withOpacity(.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: lime,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: lime,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(.45),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                current,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '/ $target',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: panel2,
              valueColor: AlwaysStoppedAnimation<Color>(lime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealCard(
    Map<String, dynamic> meal,
    int index,
  ) {
    IconData icon;

    switch (meal['type']) {
      case 'Breakfast':
        icon = Icons.wb_sunny_outlined;
        break;
      case 'Lunch':
        icon = Icons.lunch_dining_outlined;
        break;
      case 'Dinner':
        icon = Icons.nightlight_outlined;
        break;
      default:
        icon = Icons.cookie_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lime.withOpacity(.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: lime,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  meal['type'],
                  style: TextStyle(
                    color: lime,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _mealTag(
                      '${meal['calories']} kcal',
                    ),
                    _mealTag(
                      'P ${meal['protein']}g',
                    ),
                    _mealTag(
                      'C ${meal['carbs']}g',
                    ),
                    _mealTag(
                      'F ${meal['fats']}g',
                    ),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            color: panel2,
            icon: Icon(
              Icons.more_vert,
              color: Colors.white.withOpacity(.45),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _deleteMeal(index);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mealTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: panel2,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(.55),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

 

  Future<void> _showAIAnalyzer() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (image == null) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final bytes = await image.readAsBytes();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/api/analyze-meal'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: image.name,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;

      Navigator.of(context).pop();

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: panel2,
            content: Text(data['error'] ?? 'Meal analysis failed'),
          ),
        );
        return;
      }

      final meal = Map<String, dynamic>.from(data['meal']);
      _showMealAnalysisResult(meal);
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: panel2,
          content: Text('Connection error: $e'),
        ),
      );
    }
  }

  void _showMealAnalysisResult(Map<String, dynamic> meal) {
    final String name = meal['name']?.toString() ?? 'Analyzed Meal';
    final int calories = int.tryParse(meal['calories'].toString()) ?? 0;
    final double protein = double.tryParse(meal['protein'].toString()) ?? 0;
    final double carbs = double.tryParse(meal['carbs'].toString()) ?? 0;
    final double fats = double.tryParse(meal['fats'].toString()) ?? 0;
    final double confidence =
        double.tryParse(meal['confidence'].toString()) ?? 0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: lime.withOpacity(.35)),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: lime.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: lime,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'AI ANALYSIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: lime,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                _nutritionResultRow('Calories', '$calories kcal'),
                _nutritionResultRow('Protein', '${protein.toStringAsFixed(1)} g'),
                _nutritionResultRow('Carbs', '${carbs.toStringAsFixed(1)} g'),
                _nutritionResultRow('Fats', '${fats.toStringAsFixed(1)} g'),
                const SizedBox(height: 16),
                Text(
                  'Confidence: ${(confidence * 100).round()}%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: Colors.white.withOpacity(.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  meals.add({
                    'type': 'AI Analyzed',
                    'name': name,
                    'calories': calories,
                    'protein': protein.round(),
                    'carbs': carbs.round(),
                    'fats': fats.round(),
                  });
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: lime,
                    content: Text(
                      '$name added to today\'s meals.',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lime,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Text(
                'ADD TO LOG',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _nutritionResultRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: panel2,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(.5),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width > 900;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        wide ? 32 : 20,
        25,
        wide ? 32 : 20,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FUEL YOUR PERFORMANCE.',
                          style: TextStyle(
                            color: lime,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'NUTRITION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Keep your nutrition aligned with your goals.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.48),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddMealDialog,
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: const Text('ADD MEAL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // MACRO CARDS
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 650) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _macroCard(
                                title: 'CALORIES',
                                current: '$calories',
                                target: '$calorieTarget kcal',
                                progress: _progress(
                                  calories,
                                  calorieTarget,
                                ),
                                icon:
                                    Icons.local_fire_department_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _macroCard(
                                title: 'PROTEIN',
                                current: '${protein}g',
                                target: '${proteinTarget}g',
                                progress: _progress(
                                  protein,
                                  proteinTarget,
                                ),
                                icon: Icons.egg_alt_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _macroCard(
                                title: 'CARBS',
                                current: '${carbs}g',
                                target: '${carbsTarget}g',
                                progress: _progress(
                                  carbs,
                                  carbsTarget,
                                ),
                                icon: Icons.grain_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _macroCard(
                                title: 'FATS',
                                current: '${fats}g',
                                target: '${fatsTarget}g',
                                progress: _progress(
                                  fats,
                                  fatsTarget,
                                ),
                                icon: Icons.water_drop_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: _macroCard(
                          title: 'CALORIES',
                          current: '$calories',
                          target: '$calorieTarget kcal',
                          progress: _progress(
                            calories,
                            calorieTarget,
                          ),
                          icon:
                              Icons.local_fire_department_rounded,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _macroCard(
                          title: 'PROTEIN',
                          current: '${protein}g',
                          target: '${proteinTarget}g',
                          progress: _progress(
                            protein,
                            proteinTarget,
                          ),
                          icon: Icons.egg_alt_outlined,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _macroCard(
                          title: 'CARBS',
                          current: '${carbs}g',
                          target: '${carbsTarget}g',
                          progress: _progress(
                            carbs,
                            carbsTarget,
                          ),
                          icon: Icons.grain_rounded,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _macroCard(
                          title: 'FATS',
                          current: '${fats}g',
                          target: '${fatsTarget}g',
                          progress: _progress(
                            fats,
                            fatsTarget,
                          ),
                          icon: Icons.water_drop_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // AI ANALYZER
              InkWell(
                onTap: _showAIAnalyzer,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        lime.withOpacity(.12),
                        panel,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: lime.withOpacity(.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: lime,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: lime.withOpacity(.25),
                              blurRadius: 22,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI MEAL ANALYZER',
                              style: TextStyle(
                                color: lime,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Snap your meal. Know your macros.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'AI-powered nutrition estimation from your food photo.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.45),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: lime,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // TODAY'S MEALS
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S MEALS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Everything you have logged today.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${meals.length} MEALS',
                    style: TextStyle(
                      color: lime,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (meals.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        color: Colors.white.withOpacity(.2),
                        size: 42,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'NO MEALS LOGGED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add your first meal to start tracking.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(
                  meals.length,
                  (index) => _mealCard(
                    meals[index],
                    index,
                  ),
                ),

              const SizedBox(height: 14),

              // DAILY SUMMARY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 15,
                  spacing: 25,
                  children: [
                    _summaryItem(
                      'CALORIES LEFT',
                      '${(calorieTarget - calories).clamp(0, calorieTarget)} kcal',
                    ),
                    _summaryItem(
                      'PROTEIN LEFT',
                      '${(proteinTarget - protein).clamp(0, proteinTarget)}g',
                    ),
                    _summaryItem(
                      'CARBS LEFT',
                      '${(carbsTarget - carbs).clamp(0, carbsTarget)}g',
                    ),
                    _summaryItem(
                      'FATS LEFT',
                      '${(fatsTarget - fats).clamp(0, fatsTarget)}g',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(.38),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: lime,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
// ============================================================
// PROGRESS PAGE
// ============================================================

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final List<Map<String, dynamic>> weightHistory = [
    {'date': DateTime(2026, 7, 7), 'weight': 71.4},
    {'date': DateTime(2026, 7, 14), 'weight': 71.0},
    {'date': DateTime(2026, 7, 21), 'weight': 70.6},
    {'date': DateTime(2026, 7, 28), 'weight': 70.2},
    {'date': DateTime(2026, 8, 4), 'weight': 69.8},
    {'date': DateTime(2026, 8, 11), 'weight': 69.5},
    {'date': DateTime(2026, 8, 18), 'weight': 69.2},
    {'date': DateTime(2026, 8, 25), 'weight': 69.0},
  ];

  final Map<String, double> personalRecords = {
    'Bench Press': 80,
    'Squat': 100,
    'Deadlift': 120,
  };

  double get currentWeight =>
      weightHistory.isEmpty ? 69.0 : (weightHistory.last['weight'] as num).toDouble();

  double get previousWeight {
    if (weightHistory.length < 2) return currentWeight;
    return (weightHistory[weightHistory.length - 2]['weight'] as num).toDouble();
  }

  double get weightChange => currentWeight - previousWeight;

  double get totalWeightChange {
    if (weightHistory.length < 2) return 0;
    final first = (weightHistory.first['weight'] as num).toDouble();
    return currentWeight - first;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _signedWeight(double value) {
    if (value > 0) return '+${value.toStringAsFixed(1)} kg';
    if (value < 0) return '${value.toStringAsFixed(1)} kg';
    return '0.0 kg';
  }

  void _showAddWeightDialog() {
    final weightController = TextEditingController(
      text: currentWeight.toStringAsFixed(1),
    );
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: panel,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: border),
              ),
              title: const Text(
                'LOG WEIGHT',
                style: TextStyle(
                  color: lime,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: weightController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(.45),
                      ),
                      prefixIcon: const Icon(
                        Icons.monitor_weight_outlined,
                        color: lime,
                      ),
                      filled: true,
                      fillColor: panel2,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: lime),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: lime,
                                onPrimary: Colors.black,
                                surface: panel,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: panel2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: lime,
                            size: 19,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatDate(selectedDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white38,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lime,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final value = double.tryParse(weightController.text.trim());
                    if (value == null || value <= 0 || value > 500) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Please enter a valid weight.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      weightHistory.removeWhere((entry) {
                        final date = entry['date'] as DateTime;
                        return date.year == selectedDate.year &&
                            date.month == selectedDate.month &&
                            date.day == selectedDate.day;
                      });
                      weightHistory.add({
                        'date': selectedDate,
                        'weight': value,
                      });
                      weightHistory.sort(
                        (a, b) =>
                            (a['date'] as DateTime).compareTo(b['date'] as DateTime),
                      );
                    });

                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        backgroundColor: lime,
                        content: Text(
                          '${value.toStringAsFixed(1)} kg logged for ${_formatDate(selectedDate)}.',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'SAVE WEIGHT',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteWeightEntry(int index) {
    final entry = weightHistory[index];
    final weight = (entry['weight'] as num).toDouble();
    final date = entry['date'] as DateTime;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: border),
          ),
          title: const Text(
            'DELETE ENTRY?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Remove ${weight.toStringAsFixed(1)} kg logged on ${_formatDate(date)}?',
            style: TextStyle(
              color: Colors.white.withOpacity(.65),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.white.withOpacity(.55)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => weightHistory.removeAt(index));
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    bool positive = true,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: lime, size: 19),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              change,
              style: TextStyle(
                color: positive ? lime : Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 850;
    final chartData = weightHistory.length > 8
        ? weightHistory.sublist(weightHistory.length - 8)
        : List<Map<String, dynamic>>.from(weightHistory);

    final currentChangeText = weightHistory.length < 2
        ? 'First entry'
        : _signedWeight(weightChange);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isWide ? 32 : 20,
        25,
        isWide ? 32 : 20,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SEE THE WORK. OWN THE PROGRESS.',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Track your weight. Watch the trend. Keep getting stronger.',
                          style: TextStyle(color: Color(0x73FFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    onPressed: _showAddWeightDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('LOG WEIGHT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _statCard(
                              title: 'CURRENT WEIGHT',
                              value: '${currentWeight.toStringAsFixed(1)} kg',
                              change: currentChangeText,
                              icon: Icons.monitor_weight_outlined,
                              positive: weightChange <= 0,
                            ),
                            const SizedBox(width: 12),
                            _statCard(
                              title: 'ENTRIES',
                              value: '${weightHistory.length}',
                              change: 'WEIGHT LOGS',
                              icon: Icons.history_rounded,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _statCard(
                              title: 'TOTAL CHANGE',
                              value: _signedWeight(totalWeightChange),
                              change: 'SINCE FIRST LOG',
                              icon: Icons.trending_down_rounded,
                              positive: totalWeightChange <= 0,
                            ),
                            const SizedBox(width: 12),
                            _statCard(
                              title: 'LATEST LOG',
                              value: weightHistory.isEmpty
                                  ? '--'
                                  : _formatShortDate(
                                      weightHistory.last['date'] as DateTime,
                                    ),
                              change: 'MOST RECENT',
                              icon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      _statCard(
                        title: 'CURRENT WEIGHT',
                        value: '${currentWeight.toStringAsFixed(1)} kg',
                        change: currentChangeText,
                        icon: Icons.monitor_weight_outlined,
                        positive: weightChange <= 0,
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        title: 'ENTRIES',
                        value: '${weightHistory.length}',
                        change: 'WEIGHT LOGS',
                        icon: Icons.history_rounded,
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        title: 'TOTAL CHANGE',
                        value: _signedWeight(totalWeightChange),
                        change: 'SINCE FIRST LOG',
                        icon: Icons.trending_down_rounded,
                        positive: totalWeightChange <= 0,
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        title: 'LATEST LOG',
                        value: weightHistory.isEmpty
                            ? '--'
                            : _formatShortDate(
                                weightHistory.last['date'] as DateTime,
                              ),
                        change: 'MOST RECENT',
                        icon: Icons.calendar_today_outlined,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 22),

              DashboardCard(
                title: 'WEIGHT TREND',
                trailing: chartData.isEmpty
                    ? 'NO DATA'
                    : '${chartData.length} RECENT LOGS',
                child: Column(
                  children: [
                    SizedBox(
                      height: 260,
                      child: chartData.isEmpty
                          ? Center(
                              child: Text(
                                'Log your first weight to see your trend.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.40),
                                ),
                              ),
                            )
                          : CustomPaint(
                              painter: ProgressChartPainter(
                                data: chartData,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${currentWeight.toStringAsFixed(1)} kg',
                                      style: const TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'CURRENT',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.35),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    if (chartData.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatShortDate(chartData.first['date'] as DateTime),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            _formatShortDate(chartData.last['date'] as DateTime),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 22),

              DashboardCard(
                title: 'WEIGHT HISTORY',
                trailing: 'LATEST FIRST',
                child: weightHistory.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          'No weight entries yet.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.40),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(weightHistory.length, (reverseIndex) {
                          final index = weightHistory.length - 1 - reverseIndex;
                          final entry = weightHistory[index];
                          final weight = (entry['weight'] as num).toDouble();
                          final date = entry['date'] as DateTime;
                          final change = index == 0
                              ? 0.0
                              : weight -
                                  (weightHistory[index - 1]['weight'] as num)
                                      .toDouble();

                          return _weightHistoryRow(
                            index: index,
                            date: date,
                            weight: weight,
                            change: change,
                          );
                        }),
                      ),
              ),

              const SizedBox(height: 22),

              DashboardCard(
                title: 'PERSONAL RECORDS',
                trailing: 'CURRENT BEST',
                child: Column(
                  children: personalRecords.entries.map((entry) {
                    return PRRow(
                      exercise: entry.key,
                      value: '${entry.value.toStringAsFixed(0)} kg',
                      increase: '+PR',
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weightHistoryRow({
    required int index,
    required DateTime date,
    required double weight,
    required double change,
  }) {
    final isLatest = index == weightHistory.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF22262C)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isLatest ? lime.withOpacity(.13) : panel2,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.monitor_weight_outlined,
              color: isLatest ? lime : Colors.white38,
              size: 19,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isLatest ? 'LATEST ENTRY' : 'WEIGHT CHECK-IN',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .7,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${weight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 58,
            child: Text(
              index == 0 ? '--' : _signedWeight(change),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: index == 0
                    ? Colors.white30
                    : change <= 0
                        ? lime
                        : Colors.redAccent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => _deleteWeightEntry(index),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white30,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================
// ============================================================
// SETTINGS
// ============================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 25, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MAKE KINETIQ YOURS.',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Manage your preferences and profile.',
            style: TextStyle(color: const Color(0x73FFFFFF)),
          ),
          const SizedBox(height: 28),
          DashboardCard(
            title: 'PROFILE',
            trailing: 'ATHLETE',
            child: Column(
              children: [
                const SettingRow(
                  icon: Icons.person_outline_rounded,
                  title: 'Name',
                  value: 'Aeraf',
                ),
                const SettingRow(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight',
                  value: '69 kg',
                ),
                const SettingRow(
                  icon: Icons.flag_outlined,
                  title: 'Goal',
                  value: 'Build Muscle',
                ),
                SettingRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  value: 'Enabled',
                  trailingWidget: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: lime,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE UI
// ============================================================

class GlowButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const GlowButton({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: lime.withOpacity(.22),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 19),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: .8,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: lime,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: 21,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class GoalCircle extends StatelessWidget {
  const GoalCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 175,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: lime,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: lime.withOpacity(.16),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '72%',
            style: TextStyle(
              fontSize: 39,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'WEEKLY GOAL',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: const Color(0x73FFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final String change;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: lime, size: 19),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            change,
            style: const TextStyle(
              color: lime,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String trailing;
  final Widget child;

  const DashboardCard({
    super.key,
    required this.title,
    required this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
              const Spacer(),
              Text(
                trailing,
                style: const TextStyle(
                  color: lime,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          child,
        ],
      ),
    );
  }
}

class ExerciseRow extends StatelessWidget {
  final String number;
  final String exercise;
  final String sets;
  final String reps;

  const ExerciseRow({
    super.key,
    required this.number,
    required this.exercise,
    required this.sets,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF22262C)),
        ),
      ),
      child: Row(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: lime,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              exercise,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 75,
            child: Text(
              sets,
              style: const TextStyle(
                color: const Color(0x73FFFFFF),
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              reps,
              style: const TextStyle(
                color: const Color(0x73FFFFFF),
                fontSize: 11,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_outline,
            color: Colors.white24,
            size: 19,
          ),
        ],
      ),
    );
  }
}

class NutritionProgress extends StatelessWidget {
  final String label;
  final String current;
  final String target;
  final double progress;

  const NutritionProgress({
    super.key,
    required this.label,
    required this.current,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$current / $target',
              style: const TextStyle(
                color: const Color(0x73FFFFFF),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: const Color(0xFF292E34),
            valueColor: const AlwaysStoppedAnimation(lime),
          ),
        ),
      ],
    );
  }
}

class ActivityBar extends StatelessWidget {
  final String day;
  final double value;

  const ActivityBar({
    super.key,
    required this.day,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 34,
          height: 120 * value,
          decoration: BoxDecoration(
            color: lime,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: lime.withOpacity(.15),
                blurRadius: 15,
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        Text(
          day,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// WORKOUT COMPONENTS
// ============================================================

class WorkoutExerciseCard extends StatelessWidget {
  final int index;
  final String name;
  final String sets;
  final String reps;
  final String weight;
  final bool completed;
  final VoidCallback onComplete;

  const WorkoutExerciseCard({
    super.key,
    required this.index,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.completed,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: completed ? lime.withOpacity(.07) : panel,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: completed
              ? lime.withOpacity(.4)
              : border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: completed
                  ? lime
                  : lime.withOpacity(.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                  )
                : Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: lime,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    workoutInfo(Icons.repeat, '$sets sets'),
                    const SizedBox(width: 18),
                    workoutInfo(Icons.fitness_center, weight),
                    const SizedBox(width: 18),
                    workoutInfo(Icons.speed, '$reps reps'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          OutlinedButton(
            onPressed: onComplete,
            style: OutlinedButton.styleFrom(
              foregroundColor: completed ? lime : Colors.white70,
              side: BorderSide(
                color: completed ? lime : border,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              completed ? 'DONE' : 'COMPLETE',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget workoutInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white30,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: const Color(0x73FFFFFF),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// NUTRITION COMPONENTS
// ============================================================

class MacroCard extends StatelessWidget {
  final String title;
  final String value;
  final String target;
  final double progress;
  final IconData icon;

  const MacroCard({
    super.key,
    required this.title,
    required this.value,
    required this.target,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: lime, size: 21),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            '/ $target',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF292E34),
              valueColor: const AlwaysStoppedAnimation(lime),
            ),
          ),
        ],
      ),
    );
  }
}

class MealRow extends StatelessWidget {
  final IconData icon;
  final String meal;
  final String description;
  final String calories;

  const MealRow({
    super.key,
    required this.icon,
    required this.meal,
    required this.description,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF22262C)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: lime.withOpacity(.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: lime),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: const TextStyle(
              color: lime,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROGRESS COMPONENTS
// ============================================================

class ProgressStat extends StatelessWidget {
  final String title;
  final String value;
  final String change;

  const ProgressStat({
    super.key,
    required this.title,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            change,
            style: const TextStyle(
              color: lime,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PRRow extends StatelessWidget {
  final String exercise;
  final String value;
  final String increase;

  const PRRow({
    super.key,
    required this.exercise,
    required this.value,
    required this.increase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF22262C)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            color: lime,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              exercise,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 25),
          Text(
            increase,
            style: const TextStyle(
              color: lime,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  ProgressChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final linePaint = Paint()
      ..color = lime
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.06)
      ..strokeWidth = 1;

    final pointPaint = Paint()..color = lime;
    final glowPaint = Paint()
      ..color = lime.withOpacity(.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    const topPadding = 25.0;
    const bottomPadding = 25.0;
    final chartHeight = size.height - topPadding - bottomPadding;

    for (int i = 0; i < 5; i++) {
      final y = topPadding + chartHeight * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final weights = data
        .map((entry) => (entry['weight'] as num).toDouble())
        .toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final range = (maxWeight - minWeight).abs();
    final padding = range < 1 ? 1.0 : range * .20;
    final minY = minWeight - padding;
    final maxY = maxWeight + padding;
    final valueRange = maxY - minY;

    final points = <Offset>[];
    for (int i = 0; i < weights.length; i++) {
      final x = weights.length == 1
          ? size.width / 2
          : size.width * i / (weights.length - 1);
      final normalized = (weights[i] - minY) / valueRange;
      final y = topPadding + chartHeight * (1 - normalized);
      points.add(Offset(x, y));
    }

    if (points.length == 1) {
      canvas.drawCircle(points.first, 9, glowPaint);
      canvas.drawCircle(points.first, 5, pointPaint);
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      path.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 8, glowPaint);
      canvas.drawCircle(point, 4.5, pointPaint);
      canvas.drawCircle(
        point,
        2,
        Paint()..color = bg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ProgressChartPainter oldDelegate) {
    return true;
  }
}

// ============================================================
// SETTINGS COMPONENT
// ============================================================

class SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailingWidget;

  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF22262C)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: lime, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailingWidget != null)
            trailingWidget!
          else
            Text(
              value,
              style: const TextStyle(
                color: const Color(0x73FFFFFF),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}




