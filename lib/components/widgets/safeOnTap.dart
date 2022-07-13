import 'package:flutter/material.dart';

class SafeOnTap extends StatefulWidget {
  SafeOnTap({
    Key? key,
    required this.child,
    required this.onSafeTap,
    this.intervalMs = 500,
  }) : super(key: key);
  final Widget child;
  final GestureTapCallback onSafeTap;
  final int intervalMs;

  @override
  _SafeOnTapState createState() => _SafeOnTapState();
}

class _SafeOnTapState extends State<SafeOnTap> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastTimeClicked < widget.intervalMs) {
          return;
        }
        lastTimeClicked = now;
        widget.onSafeTap();
      },
      child: widget.child,
    );
  }
}