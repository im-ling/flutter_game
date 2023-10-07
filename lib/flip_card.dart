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

  void testFunction() {
    print("test");
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
        duration: const Duration(milliseconds: 500),
        child: isFront
            ? Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Text(
                  "front",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              )
            : Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Text(
                  "back",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
      ),
    );
  }
}
