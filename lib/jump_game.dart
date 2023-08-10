import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class JumpGamePage extends StatefulWidget {
  const JumpGamePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<JumpGamePage> createState() => _JumpGamePageState();
}

const double stageSize = 300;
const double size = 30;
double wallHeight = 60;
const double stepInitial = 2;

enum Direction { up, down, none }

enum GameState { running, dead }

class _JumpGamePageState extends State<JumpGamePage> {
  double marioY = stageSize;
  double wallX = stageSize;
  Direction direction = Direction.none;
  GameState gameState = GameState.running;
  double score = 0;
  double step = stepInitial;

  @override
  void didChangeDependencies() {
    Timer.periodic(const Duration(milliseconds: 5), (timer) {
      double newMarioY = marioY;
      Direction newDirection = direction;
      switch (direction) {
        case Direction.up:
          step = step - 0.01;
          newMarioY -= step;
          if (newMarioY < 150) {
            newMarioY = 150;
            step = 0.5;
            newDirection = Direction.down;
          }
          break;
        case Direction.down:
          step = step + 0.015;
          newMarioY += step;
          if (newMarioY > stageSize) {
            step = stepInitial;
            newMarioY = stageSize;
            newDirection = Direction.none;
          }
          break;
        default:
      }

      if (wallX < size && marioY > stageSize - wallHeight) {
        setState(() {
          gameState = GameState.dead;
        });
      } else {
        setState(() {
          score = score + 0.1;

          wallX = wallX - 1 + stageSize;
          if (wallX < stageSize) {
            wallHeight = Random().nextDouble() * 60 + 20;
          }
          wallX = wallX % stageSize;

          marioY = newMarioY;
          direction = newDirection;
        });
      }
    });
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: gameState == GameState.running ? buildGame() : buildDead(),
        ),
      ),
    );
  }

  Widget buildDead() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      // color: Colors.blueAccent,
      width: stageSize,
      height: stageSize,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("High Scores:${score.toInt()}"),
          const SizedBox(
            height: 5,
          ),
          const Text("Game Over"),
          TextButton(
            onPressed: () {
              reset();
            },
            child: const Text("Retry"),
          )
        ],
      )),
    );
  }

  void reset() {
    marioY = stageSize;
    wallX = stageSize;
    direction = Direction.none;
    gameState = GameState.running;
    score = 0;
    step = stepInitial;
  }

  Widget buildGame() {
    return GestureDetector(
      onTap: () {
        if (direction == Direction.none) {
          setState(() {
            direction = Direction.up;
          });
        }
      },
      child: Container(
        width: stageSize,
        height: stageSize,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: Stack(
          children: [
            // mario
            Positioned.fromRect(
              rect: Rect.fromCenter(
                  center: Offset(size / 2.0, marioY - size / 2.0),
                  width: size,
                  height: size),
              child: Container(
                color: Colors.orange,
                child: Image.asset("images/mario2.png"),
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCenter(
                  center: Offset(wallX, stageSize - wallHeight / 2.0),
                  width: size,
                  height: wallHeight),
              child: Container(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 60,
              child: Center(
                child: Text("Score:${score.toInt()}"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
