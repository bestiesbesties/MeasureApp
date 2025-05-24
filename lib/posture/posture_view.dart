import 'package:flutter/material.dart';

class PostureView extends StatelessWidget {
  const PostureView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final isLandscape = width > height;
    final double imageSize = isLandscape ? height * 0.7 : width * 0.7;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/feet-icon-correct.png', // Placeholder for the image
              width: imageSize,
              height: imageSize,
            ),
            const SizedBox(height: 30),
            Text(
              'Je posture is goed, blijf even staan.', // Placeholder for the text
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
