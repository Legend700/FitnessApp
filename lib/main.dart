import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ABXFIT());
}

class ABXFIT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABXFIT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User?> _signInWithEmailPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ABXFIT - Sign In")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = await _signInWithEmailPassword();
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                }
              },
              child: Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to ABXFIT")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddWorkoutScreen()),
                );
              },
              child: Text("Add Workout"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewWorkoutsScreen()),
                );
              },
              child: Text("View Workouts"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MealLogScreen()),
                );
              },
              child: Text("Log Meal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecommendationsScreen()),
                );
              },
              child: Text("AI Recommendations"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _workoutController = TextEditingController();
  final _durationController = TextEditingController();

  Future<void> _addWorkout() async {
    final workout = _workoutController.text;
    final duration = _durationController.text;

    if (workout.isNotEmpty && duration.isNotEmpty) {
      await FirebaseFirestore.instance.collection('workouts').add({
        'workout': workout,
        'duration': duration,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Workout")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(labelText: "Workout Type"),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: "Duration (mins)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWorkout,
              child: Text("Save Workout"),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewWorkoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Workouts")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No workouts logged yet"));
          }
          final workouts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return ListTile(
                title: Text(workout['workout']),
                subtitle: Text("Duration: ${workout['duration']} mins"),
              );
            },
          );
        },
      ),
    );
  }
}

class MealLogScreen extends StatefulWidget {
  @override
  _MealLogScreenState createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  final _mealController = TextEditingController();
  final _caloriesController = TextEditingController();

  Future<void> _logMeal() async {
    final meal = _mealController.text;
    final calories = _caloriesController.text;

    if (meal.isNotEmpty && calories.isNotEmpty) {
      await FirebaseFirestore.instance.collection('meals').add({
        'meal': meal,
        'calories': calories,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log Meal")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mealController,
              decoration: InputDecoration(labelText: "Meal Type"),
            ),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: "Calories"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logMeal,
              child: Text("Save Meal"),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Recommendations")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Based on your recent workouts, we recommend the following workout:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Workout: Full Body Strength Training",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Duration: 45 minutes"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to workout details or log the recommended workout
              },
              child: Text("Start Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
