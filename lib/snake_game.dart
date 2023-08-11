import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction { up, down, left, right }

enum GameState { running, dead }

class SnakeGmePage extends StatefulWidget {
  const SnakeGmePage({super.key});

  @override
  State<SnakeGmePage> createState() => _SnakeGmePageState();
}

double maxWidth = 300;
double maxHeight = 300;

class _SnakeGmePageState extends State<SnakeGmePage> {
  String title = "Snake";

  Offset ball = Offset(0, 10);

  double size = 10;

  Direction direction = Direction.left;

  List<Offset> snakeList = [const Offset(50, 0), const Offset(60, 0)];

  bool isAutoGame = false;

  int score = 0;
  GameState gameState = GameState.running;

  bool isDispose = false;

  @override
  void dispose() {
    isDispose = true;
    // TODO: implement dispose
    super.dispose();
  }

  Direction autoGame(Offset snakeHead) {
    var newDirection = direction;
    if (direction == Direction.down && snakeHead.dx == 0) {
      newDirection = Direction.right;
    }

    if (direction == Direction.down &&
        snakeHead.dx == maxWidth - size &&
        snakeHead.dy ~/ 10 % 2 == 0) {
      newDirection = Direction.left;
    }

    if (direction == Direction.left &&
        snakeHead.dx == 0 &&
        (snakeHead.dy % size) % 2 == 0) {
      newDirection = Direction.down;
    }
    if (direction == Direction.right &&
        snakeHead.dx == maxWidth - size &&
        snakeHead.dy ~/ 10 % 2 == 1) {
      newDirection = Direction.down;
    }

    return newDirection;
  }

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final snakeHead = snakeList[0];
      var newDirection = direction;
      if (isAutoGame) newDirection = autoGame(snakeHead);

      List<Offset> newSnakeList = List.generate(snakeList.length, (index) {
        if (index > 0) {
          return snakeList[index - 1];
        } else {
          switch (newDirection) {
            case Direction.up:
              return Offset(
                  snakeHead.dx, (snakeHead.dy - size + maxHeight) % maxHeight);
            case Direction.down:
              return Offset(snakeHead.dx, (snakeHead.dy + size) % maxHeight);
            case Direction.left:
              return Offset(
                  (snakeHead.dx - size + maxWidth) % maxWidth, snakeHead.dy);
            case Direction.right:
              return Offset(
                  (snakeHead.dx + size + maxWidth) % maxWidth, snakeHead.dy);
          }
        }
      });

      if (newSnakeList[0] == ball) {
        newSnakeList.add(snakeList.last);
        snakeList = newSnakeList;
        ball = newBall();
        score += 1;
      }
      snakeList = newSnakeList;
      direction = newDirection;

      for (int i = 1; i < snakeList.length; i++) {
        if (snakeList[i].dx == snakeList[0].dx &&
            snakeList[i].dy == snakeList[0].dy) {
          gameState = GameState.dead;
        }
      }
      if (isDispose) {
        timer.cancel();
        return;
      }
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  Offset newBall() {
    var dx = Random().nextInt(maxWidth.toInt());
    dx = dx - dx % 10;
    var dy = Random().nextInt(maxHeight.toInt());
    dy = dy - dy % 10;
    var newOffset = Offset(dx.toDouble(), dy.toDouble());
    if (snakeList.contains(newOffset)) {
      return newBall();
    }
    return newOffset;
  }

  Widget buildGame() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        var newDirection = direction;
        if (event.runtimeType == RawKeyDownEvent) {
          switch (event.logicalKey.keyLabel) {
            case "Arrow Down":
              if (direction != Direction.up) newDirection = Direction.down;
              break;
            case "Arrow Up":
              if (direction != Direction.down) newDirection = Direction.up;
              break;
            case "Arrow Left":
              if (direction != Direction.right) newDirection = Direction.left;
              break;
            case "Arrow Right":
              if (direction != Direction.left) newDirection = Direction.right;
              break;
            default:
          }
        }
        setState(() {
          direction = newDirection;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Score: $score"),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.blueAccent,
            width: maxWidth,
            height: maxHeight,
            child: Stack(
              children: snakeList
                  .map(
                    (e) => Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: addjust(e), width: size, height: size),
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )
                  .toList()
                ..add(Positioned.fromRect(
                  rect: Rect.fromCenter(
                      center: addjust(ball), width: size, height: size),
                  child: Container(
                    color: Colors.orange,
                  ),
                )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildKeyBoard(),
        ],
      ),
    );
  }

  Widget buildKeyBoard() {
    if (Platform.isIOS || Platform.isAndroid) {
      return Container(
        width: 120,
        height: 120,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  if (direction != Direction.down) direction = Direction.up;
                },
                icon: const Icon(Icons.keyboard_arrow_up),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                      if (direction != Direction.right) {
                        direction = Direction.left;
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_left),
                  ),
                ),
                const SizedBox(
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                      if (direction != Direction.left) {
                        direction = Direction.right;
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  if (direction != Direction.up) {
                    direction = Direction.down;
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  Offset addjust(Offset offset) {
    // return offset;
    return Offset(offset.dx + size / 2.0, offset.dy + size / 2);
  }

  Widget buildDead() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      // color: Colors.blueAccent,
      width: maxWidth,
      height: maxHeight,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("High Scores:$score"),
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
    ball = Offset(0, 10);
    direction = Direction.left;
    snakeList = [const Offset(50, 0), const Offset(60, 0)];
    score = 0;
    gameState = GameState.running;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: gameState == GameState.running ? buildGame() : buildDead(),
        ),
      ),
    );
    ;
  }
}
