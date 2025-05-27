import 'package:flutter/material.dart';

class MeasureAwait extends StatelessWidget {
  const MeasureAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MeasureView extends StatelessWidget {
  const MeasureView({super.key});

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
              "Blijf even staan, de meting wordt uitgevoerd",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            // if still data is still in progress, show this indicator
            CircularProgressIndicator(
              strokeWidth: 2.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF5382DE),
              ),
            ),

            //else show measure data

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