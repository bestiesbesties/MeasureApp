import 'package:flutter/material.dart';

class MeasureDefault extends StatelessWidget {
  const MeasureDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/feet-icon-default.png", width: 200, height: 200),
            const SizedBox(height: 30),
            Text(
              "Jouw ?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}