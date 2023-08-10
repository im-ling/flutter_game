import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction { up, down, left, right }

class SnakeGmePage extends StatefulWidget {
  const SnakeGmePage({super.key});

  @override
  State<SnakeGmePage> createState() => _SnakeGmePageState();
}

double maxWidth = 300;
double maxHeight = 300;

class _SnakeGmePageState extends State<SnakeGmePage> {
  String title = "Snake";

  Offset ball = Offset.zero;

  double size = 10;

  Direction direction = Direction.left;

  List<Offset> snakeList = [const Offset(50, 0), const Offset(60, 0)];

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final snakeHead = snakeList[0];

      List<Offset> newSnakeList = List.generate(snakeList.length, (index) {
        if (index > 0) {
          return snakeList[index - 1];
        } else {
          switch (direction) {
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
      }
      snakeList = newSnakeList;

      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  Offset newBall() {
    var dx = Random().nextInt(maxWidth.toInt() + 1);
    dx = dx - dx % 10;
    var dy = Random().nextInt(maxHeight.toInt() + 1);
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
      child: Container(
        color: Colors.blueAccent,
        width: maxWidth.toDouble(),
        height: maxHeight.toDouble(),
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
    );
  }

  Offset addjust(Offset offset) {
    // return offset;
    return Offset(offset.dx + size / 2.0, offset.dy + size / 2);
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
          child: buildGame(),
        ),
      ),
    );
    ;
  }
}
