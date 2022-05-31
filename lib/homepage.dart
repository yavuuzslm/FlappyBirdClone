import 'dart:async';

import 'package:flappy_bird_clone/collisionAreas.dart';
import 'package:flutter/material.dart';

import 'bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // hero variables
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYAxis;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool isGameStarted = false; // game variable

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];
  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  bool birdIsDead() {
    if (birdYAxis < -1 || birdYAxis > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYAxis <= -1 + barrierHeight[i][0] ||
              birdHeight + birdYAxis > barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void startGame() {
    isGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdYAxis = initialHeight - height;
      });

      moveMap();

      if (birdIsDead()) {
        timer.cancel();
        isGameStarted = false; // stop the timer
        _showDialog();
      }
      time += 0.01; // increase time constantly
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'Game Over',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text('Do you want to play again?'),
          actions: <Widget>[
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYAxis = 0;
      isGameStarted = false;
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isGameStarted ? jump() : startGame();
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Stack(
                  children: [
                    MyBird(
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                        birdY: birdYAxis),
                    Container(
                      child: isGameStarted
                          ? Text(" ")
                          : Text(" T A P  T O  P L A Y ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                      alignment: Alignment(0, -0.25),
                    ),
                    GameCollisions(
                      isThisBottomBarrier: false,
                      barrierXPosition: barrierX[0],
                      barrierHeight: barrierHeight[0][0],
                      barrierWidth: barrierWidth,
                    ),
                    GameCollisions(
                        isThisBottomBarrier: true,
                        barrierXPosition: barrierX[0],
                        barrierHeight: barrierHeight[0][1],
                        barrierWidth: barrierWidth),
                    GameCollisions(
                        isThisBottomBarrier: false,
                        barrierXPosition: barrierX[1],
                        barrierHeight: barrierHeight[1][0],
                        barrierWidth: barrierWidth),
                    GameCollisions(
                        isThisBottomBarrier: true,
                        barrierXPosition: barrierX[1],
                        barrierHeight: barrierHeight[1][1],
                        barrierWidth: barrierWidth),
                  ],
                ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Score",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("0",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "High Score",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "0",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
