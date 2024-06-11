import 'dart:async';

import 'package:brick_breakers/ball.dart';
import 'package:brick_breakers/brick.dart';
import 'package:brick_breakers/coverscreen.dart';
import 'package:brick_breakers/gameoverscreen.dart';
import 'package:brick_breakers/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  var ballyDirection = direction.DOWN;
  var ballxDirection = direction.LEFT;

  // player variables
  double playerX = -0.2;
  double playerWidth = 0.4; // out of 2

  // brick variables
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4; // out of 2
  static double brickHeight = 0.05; // out of 2
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 4;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);

  List MyBricks = [
    // [x, y, broken = true/false]
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
  ];

  //game settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  // start game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // update direction
      updateDirection();

      // move ball
      moveBall();

      // check if player daed
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check if brick hit
      checkForBrokenBricks();
    });
  }

  // brick broken
  void checkForBrokenBricks() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          // brick broken update ball direction
          //based on wich side the ball hit
          // to do this calculate the distance from the ball to each side
          // the shortest distance is the side the ball hit

          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballxDirection = direction.LEFT;

              break;
            case 'right':
              ballxDirection = direction.RIGHT;

              break;
            case 'up':
              ballyDirection = direction.UP;

              break;
            case 'down':
              ballyDirection = direction.DOWN;

              break;
          }
        });
      }
    }
  }

  // return the smallest side
  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];

    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if(myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }

    return "";
  }

  // is player dead?
  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }

    return false;
  }

  // move ball
  void moveBall() {
    setState(() {
      // move horizontal
      if (ballxDirection == direction.LEFT) {
        ballX -= ballXincrements;
      } else if (ballxDirection == direction.RIGHT) {
        ballX += ballXincrements;
      }
      // move vertical
      if (ballyDirection == direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballyDirection == direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }

  // update direction of the ball
  void updateDirection() {
    setState(() {
      // move ball up when player is hit
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballyDirection = direction.UP;
        // move ball down when hitting the top of the screen
      } else if (ballY <= -1) {
        ballyDirection = direction.DOWN;
      }
      // move ball left when hitting the right wall
      if (ballX >= 1) {
        ballxDirection = direction.LEFT;
      }
      // move ball right when hitting the left wall
      else if (ballX <= -1) {
        ballxDirection = direction.RIGHT;
      }
    });
  }

  // move player left
  void moveLeft() {
    setState(() {
      if (!(playerX - 0.2 <= -1.2)) {
        playerX -= 0.2;
      }
    });
  }

  // move player right
  void moveRight() {
    setState(() {
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2;
      }
    });
  }

  //reset game back to original valeus
  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      MyBricks = [
        // [x, y, broken = true/false]
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
              child: Stack(
            children: [
              // tap to play
              CoverScreen(
                hasGameStarted: hasGameStarted),
              GameOverScreen(
                isGameOver: isGameOver,
                function: resetGame,),
              //ball
              MyBall(
                ballX: ballX,
                ballY: ballY,
              ),
              //player
              MyPlayer(
                playerX: playerX,
                playerWidth: playerWidth,
              ),
              // bricks
              MyBrick(
                brickX: MyBricks[0][0],
                brickY: MyBricks[0][1],
                brickBroken: MyBricks[0][2],
                brickHeight: brickHeight,
                brickWidth: brickWidth,
              ),
              MyBrick(
                brickX: MyBricks[1][0],
                brickY: MyBricks[1][1],
                brickBroken: MyBricks[1][2],
                brickHeight: brickHeight,
                brickWidth: brickWidth,
              ),
              MyBrick(
                brickX: MyBricks[2][0],
                brickY: MyBricks[2][1],
                brickBroken: MyBricks[2][2],
                brickHeight: brickHeight,
                brickWidth: brickWidth,
              ),
              MyBrick(
                brickX: MyBricks[3][0],
                brickY: MyBricks[3][1],
                brickBroken: MyBricks[3][2],
                brickHeight: brickHeight,
                brickWidth: brickWidth,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
