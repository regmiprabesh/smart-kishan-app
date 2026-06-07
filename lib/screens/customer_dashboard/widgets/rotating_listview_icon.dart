import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';

class RotatingListViewIcon extends StatefulWidget {
  final Function(bool isListView) onTap;
  final bool currentValue;
  const RotatingListViewIcon(
      {Key? key, required this.onTap, required this.currentValue})
      : super(key: key);

  @override
  _RotatingListViewIconState createState() => _RotatingListViewIconState();
}

class _RotatingListViewIconState extends State<RotatingListViewIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    setState(() {
      _isListView = widget.currentValue;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleIcon() {
    if (_controller.isAnimating) return;

    if (_isListView) {
      _controller.forward().whenComplete(() {
        setState(() {
          _isListView = false;
        });
        widget.onTap(_isListView);
      });
    } else {
      _controller.reverse().whenComplete(() {
        setState(() {
          _isListView = true;
        });
        widget.onTap(_isListView);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: kPrimaryGrey.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SizedBox(
            height: 45,
            width: 45,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.141592653589793,
                  child: IconButton(
                    iconSize: 20,
                    color: kPrimaryColor,
                    icon: HugeIcon(
                      icon: _isListView
                          ? HugeIcons
                              .strokeRoundedMenuSquare // Replace with HugeIcons.strokeRoundedMenuSquare
                          : HugeIcons
                              .strokeRoundedCheckList, // Replace with HugeIcons.strokeRoundedCheckList
                    ),
                    onPressed: _toggleIcon,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
