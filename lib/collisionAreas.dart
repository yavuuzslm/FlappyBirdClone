import 'package:flutter/material.dart';

class GameCollisions extends StatelessWidget {
  final barrierWidth;
  final barrierHeight;
  final barrierXPosition;
  final bool isThisBottomBarrier;

  const GameCollisions(
      {Key? key,
      this.barrierHeight,
      this.barrierWidth,
      this.barrierXPosition,
      required this.isThisBottomBarrier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
          (2 * barrierXPosition + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(),
      color: Colors.green.shade400,
      width: MediaQuery.of(context).size.width * barrierWidth / 2,
      height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
    );
  }
}
