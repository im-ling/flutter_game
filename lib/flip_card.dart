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
            ? const MyCard(
                str: "正面",
                color: Colors.blue,
              )
            : const MyCard(str: "背面", color: Colors.green),
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
      width: 200,
      height: 200,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Text(
        str,
        style: TextStyle(color: color, fontSize: 32),
      ),
    );
  }
}
