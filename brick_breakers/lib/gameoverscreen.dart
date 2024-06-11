import 'package:flutter/material.dart';


class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  final function;

  // font
 

  GameOverScreen({required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(children: [ 
          Container(
              alignment: Alignment(0, -0.3),
              child: Text("G A M E  O V E R",
               style: TextStyle(color: Colors.deepPurple),),
            ),
          Container(
              alignment: Alignment(0, 0),
              child: GestureDetector(
                onTap: function,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.deepPurple,
                    child: Text("P L A Y  A G A I N",
                     style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
        ])
        : Container();
  }
}
