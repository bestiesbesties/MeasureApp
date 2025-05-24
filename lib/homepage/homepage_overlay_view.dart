import 'package:flutter/material.dart';
import 'package:wonder/homepage/homepage_overlay_content_view.dart';
import 'package:wonder/homepage/homepage.dart';

class HomepageOverlayView extends StatelessWidget {
  const HomepageOverlayView({required this.viewModel, required this.height, required this.width, super.key});
  final HomepageViewModel viewModel;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height * 0.8,
        width: width * 0.8,
        child: Material(
          color: Colors.white,
          elevation: 10,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              const HomepageOverlayContentState(),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: viewModel.toggleOverlay,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

