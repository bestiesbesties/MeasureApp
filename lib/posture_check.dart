import 'package:flutter/material.dart';

// implenment AI-model to check on foot profiel
//Front end design
//FIXME: logic implement into frontend

class PostureCheckPage extends StatefulWidget {
  const PostureCheckPage({super.key});

  @override
  _PostureCheckPageState createState() => _PostureCheckPageState();
}

class _PostureCheckPageState extends State<PostureCheckPage> {
  // if foot too much pressure on the front
  // if foot too much pressure on the back
  // if foot too much pressure on the left
  // if foot too much pressure on the right
  // if foot too much pressure on the middle

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




// visueel as feedback of profiel
// text as foodback