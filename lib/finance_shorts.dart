import 'package:flutter/material.dart';

class FinanceShortsPage extends StatelessWidget {
  const FinanceShortsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.play_circle_outline,
                size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "Finance Shorts",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Short finance videos to help users learn budgeting,\n"
              "saving, and investing.\n\nComing soon 🚀",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
