import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 760;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  void _showGameOverScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GAME OVER'),
        content: Text('You\'ve score: ${snakePosition.length}'),
        actions: [
          ElevatedButton(
            onPressed: () => startGame(),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  var direction = 'down';
  void updateSnake() {
    setState(
      () {
        switch (direction) {
          case 'down':
            if (snakePosition.last > 740) {
              snakePosition.add(snakePosition.last + 20 - 760);
            } else {
              snakePosition.add(snakePosition.last + 20);
            }
            break;
          case 'up':
            if (snakePosition.last < 20) {
              snakePosition.add(snakePosition.last - 20 + 760);
            } else {
              snakePosition.add(snakePosition.last - 20);
            }
            break;
          case 'left':
            if (snakePosition.last % 20 == 0) {
              snakePosition.add(snakePosition.last - 1 + 20);
            } else {
              snakePosition.add(snakePosition.last - 1);
            }
            break;
          case 'right':
            if ((snakePosition.last + 1) % 20 == 0) {
              snakePosition.add(snakePosition.last + 1 - 20);
            } else {
              snakePosition.add(snakePosition.last + 1);
            }
            break;
          default:
        }
        if (snakePosition.last == food) {
          generateNewFood();
        } else {
          snakePosition.removeAt(0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: Container(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    itemBuilder: (context, index) {
                      if (snakePosition.contains(index)) {
                        print('hi');
                        return ClipRRect(
                          
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey.shade900,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: startGame,
                child: const Text(
                  'S T A R T',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
