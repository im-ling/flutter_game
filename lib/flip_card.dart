import 'dart:math';

import 'package:flutter/material.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  String title = "Flip Card";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FlipCard(),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isFront = true;

  // void testFunction() {
  //   print("test");
  // }

  Widget _transitionBuilder(Widget child, Animation<double> animation) {
    final ani = Tween(begin: pi, end: 0).animate(animation);
    return AnimatedBuilder(
        animation: ani,
        builder: (BuildContext context, Widget? widget) {
          return Transform(
            transform: Matrix4.rotationY(
              ani.value.toDouble(),
            ),
            alignment: Alignment.center,
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFront = !isFront;
        });
      },
      child: AnimatedSwitcher(
        transitionBuilder: _transitionBuilder,
        duration: const Duration(milliseconds: 1000),
        child: isFront
            ? MyCard(
                key: ValueKey(true),
                str: "正面",
                color: Colors.blue,
              )
            : MyCard(key: ValueKey(false), str: "", color: Colors.green),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.str,
    required this.color,
  });

  final String str;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: 200,
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Text(
        str,
        style: const TextStyle(fontSize: 32),
      ),
    );
  }
}
