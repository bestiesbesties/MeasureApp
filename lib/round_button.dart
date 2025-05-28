import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String name;
  final VoidCallback onPressed;
  final Color? color;

  RoundButton({required this.name, required this.onPressed, this.color});

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  late Color _defaultColor;
  final Color _pressedColor = Color(0xFF1D53BF);
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _defaultColor = widget.color ?? Color(0xFF1D53BF);
    _currentColor = _defaultColor;
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _currentColor = _pressedColor;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _currentColor = _defaultColor;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _currentColor = _defaultColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: screenWidth * 0.8,
          height: 50,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
