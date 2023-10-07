import 'package:flutter/material.dart';
import 'jump_game.dart';
import 'snake_game.dart';
import 'flip_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const IndexPage(),
        // initialRoute: "/",
        routes: {
          // 静态页面
          // "/": (context) => const IndexPage(),
          "/jump_game": (context) => const JumpGamePage(),
          "/snake_game": (context) => const SnakeGmePage(),
          "/flip_card": (context) => const FlipCardPage(),
        });
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(title),
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Index",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                // color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            buildBtnWithTitleJumpString(
                context, "Snake Game", '/snake_game', {}),
            const SizedBox(
              height: 20,
            ),
            buildBtnWithTitleJumpString(context, "Jump Game", '/jump_game', {}),
            const SizedBox(
              height: 20,
            ),
            buildBtnWithTitleJumpString(context, "Flip Card", '/flip_card', {}),
          ],
        ),
      ),
    );
  }

  Widget buildBtnWithTitleJumpString(BuildContext context, String title,
      String routeName, Object? jumpArguments) {
    var arguments = jumpArguments ?? {};
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      },
      child: Container(
        width: 90,
        alignment: Alignment.center,
        child: Text(title),
      ),
    );
  }
}
