import 'dart:math';

import 'package:flutter/material.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  String title = "Flip Card";
  List<String> candidates = [];
  List<String> correctNumList = [];
  List<bool> isFrontList = List.generate(16, (index) => false);

  bool isFirstClick = true;
  String lastClickCandidate = "";
  int lastClickIdx = 0;

  void onCardTap(idx, text) {
    setState(() {
      isFrontList[idx] = !isFrontList[idx];
    });
    if (isFirstClick) {
      lastClickCandidate = text;
      lastClickIdx = idx;
    } else {
      if (idx == lastClickIdx) {
      } else {
        if (text == lastClickCandidate) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              correctNumList.add(text);
            });
          });
        } else {
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              isFrontList[idx] = false;
              isFrontList[lastClickIdx] = false;
            });
          });
        }
      }
    }
    isFirstClick = !isFirstClick;
  }

  List<String> generateCandidates() {
    List<String> result = [];
    for (int i = 0; i < 16; i++) {
      result.add((i ~/ 2 + 1).toString());
    }
    result.shuffle();
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    candidates = generateCandidates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // var padding = MediaQuery.of(context).padding;
    // double newheight = height - padding.top - padding.bottom;
    // var cardSideLength = max(width, newheight) / 4.0 - 10;
    double cardSideLength = 80;
    double interval = 10;
    // var result = cardSideLength;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SizedBox(
          width: cardSideLength * 4 + interval * 3,
          height: cardSideLength * 4 + interval * 3,
          child: Wrap(
            spacing: interval,
            runSpacing: interval,
            children: candidates
                .asMap()
                .map((idx, e) => MapEntry(
                    idx,
                    correctNumList.contains(e)
                        ? SizedBox(
                            width: cardSideLength,
                            height: cardSideLength,
                          )
                        : FlipCard(
                            sideLen: cardSideLength,
                            text: e,
                            isFront: isFrontList[idx],
                            onTap: () {
                              onCardTap(idx, e);
                            },
                          )))
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  FlipCard(
      {super.key,
      required this.sideLen,
      required this.text,
      required this.isFront,
      required this.onTap});

  double sideLen;
  String text;
  bool isFront;
  Function? onTap;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
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
    return SizedBox(
      width: widget.sideLen,
      height: widget.sideLen,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.onTap?.call();
          });
        },
        child: AnimatedSwitcher(
          transitionBuilder: _transitionBuilder,
          duration: const Duration(milliseconds: 1000),
          child: widget.isFront
              ? MyCard(
                  key: const ValueKey(true),
                  str: widget.text,
                  color: Colors.blue,
                )
              : const MyCard(
                  key: ValueKey(false), str: "", color: Colors.green),
        ),
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
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Text(
        str,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
