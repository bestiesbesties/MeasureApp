import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/posture/posture_viewmodel.dart';

class PostureView extends StatelessWidget {
  final String initialPostureId;

  const PostureView({super.key, required this.initialPostureId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _precacheAllImages(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (_) => PostureViewModel(initialPostureId),
            child: const _PostureScreen(),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<void> _precacheAllImages(BuildContext context) async {
    const imagePaths = [
      "assets/images/feet-icon-correct.png",
      "assets/images/feet-icon-wrong-left.png",
      "assets/images/feet-icon-wrong-right.png",
      "assets/images/feet-icon-wrong-toes.png",
      "assets/images/feet-icon-wrong-all.png",
      "assets/images/default.png",
    ];

    for (final path in imagePaths) {
      await precacheImage(AssetImage(path), context);
    }
  }
}


class _PostureScreen extends StatelessWidget {
  const _PostureScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostureViewModel>();
    final size = MediaQuery.of(context).size;
    final double imageSize = (size.width > size.height ? size.height : size.width) * 0.7;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(viewModel.imagePath, width: imageSize, height: imageSize),
            const SizedBox(height: 30),
            Text(
              viewModel.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (viewModel.isCountingDown)
              Text(
                "Stabiel voor: ${viewModel.countdown}s",
                style: Theme.of(context).textTheme.titleMedium,
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
