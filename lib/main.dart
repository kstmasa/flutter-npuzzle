import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N Puzzle Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'N Puzzle Game'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int level = 3;

  List<int> ordinaryList = [];
  List<int> shuffleList = [];

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    ordinaryList = getOrdinaryList(level);
    shuffleList = generateShuffleList(level);
  }

  bool isFinal(int number) {
    return number == (level * level - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 600,
                  height: 600,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    crossAxisCount: 3,
                    children: shuffleList
                        .map((e) => GestureDetector(
                              onTap: () => !isFinal(e) ? shift(e) : (),
                              child: getBox(e, isFinal(e)),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                    width: 600,
                    child: OverflowBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              startNewGame();
                            });
                          },
                          child: const Text(
                            'New Game',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        // OutlinedButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text('Back to Github!'),
                        // ),
                      ],
                    ))
              ],
            )));
  }

  Container getBox(int num, bool isFinal) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: isFinal ? Colors.transparent : Colors.teal[100],
      ),
      alignment: Alignment.center,
      child: Text(
        isFinal ? '' : (num + 1).toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  List<int> getOrdinaryList(int level) {
    return List<int>.generate(level * level, (e) => e, growable: true);
  }

  List<int> generateShuffleList(int level) {
    List<int> list = getOrdinaryList(level);
    list.shuffle();
    return list;
  }

  void shift(int number) {
    int index = shuffleList.indexOf(number);
    if (index - level >= 0 && shuffleList[index - level] == 8) {
      swap(index, index - level);
    } else if (index + level <= 8 && shuffleList[index + level] == 8) {
      swap(index, index + level);
    } else if ((index % level != 0) && shuffleList[index - 1] == 8) {
      swap(index, index - 1);
    } else if (((index + 1) % level != 0) && shuffleList[index + 1] == 8) {
      swap(index, index + 1);
    }

    if (checkWin()) {
      _showMyDialog();
    }
  }

  void swap(int preIndex, int nextIndex) {
    setState(() {
      var tmp = shuffleList[preIndex];
      shuffleList[preIndex] = shuffleList[nextIndex];
      shuffleList[nextIndex] = tmp;
    });
  }

  bool checkWin() {
    return listEquals(shuffleList, ordinaryList);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Well Done!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to play this N puzzle again?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Play again'),
              onPressed: () {
                setState(() {
                  startNewGame();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Stop'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
