import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_npuzzle/lib.dart';

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
          colorScheme: ColorScheme.light(
              inversePrimary: Colors.black,
              secondary: Colors.teal[100]!,
              surface: Colors.white,
              primary: Colors.black),
          useMaterial3: true),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(
              inversePrimary: Colors.white,
              secondary: Colors.teal[700]!,
              surface: Colors.black,
              primary: Colors.white),
          useMaterial3: true),
      themeMode: ThemeMode.system,
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
  int level = 3;
  final MyLibrary library = MyLibrary();
  List<int> dropdownList = [3, 4, 5, 6];

  List<int> ordinaryList = [];
  List<int> shuffleList = [];

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          shape: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 2)),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
                width: 500,
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(top: 8, right: 24),
                              child: Text("LEVEL",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                )),
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(24.0),
                              value: level.toString(),
                              icon: const Icon(null),
                              isExpanded: true,
                              // elevation: 16,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                              underline: Container(height: 0),
                              onChanged: (String? value) {
                                setState(() {
                                  level = int.parse(value!);
                                  startNewGame();
                                });
                              },
                              items: dropdownList
                                  .map<DropdownMenuItem<String>>((int value) {
                                return DropdownMenuItem<String>(
                                    alignment: AlignmentDirectional.center,
                                    value: value.toString(),
                                    child: Text(value.toString()));
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            // width: 500,
                            height: 500,
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              crossAxisCount: level,
                              children: shuffleList
                                  .map((e) => GestureDetector(
                                        onTap: () =>
                                            !isFinal(e) ? shift(e) : (),
                                        child: getBox(e, isFinal(e)),
                                      ))
                                  .toList(),
                            ),
                          )
                        ]))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 24),
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
                                    startNewGame();
                                  },
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text(
                                        'New Game',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      )),
                                ),
                              ],
                            )))
                  ],
                ))));
  }

  Container getBox(int num, bool isFinal) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: isFinal
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondary,
      ),
      alignment: Alignment.center,
      child: Text(
        isFinal ? '' : (num + 1).toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  void startNewGame() {
    setState(() {
      ordinaryList = getOrdinaryList(level);
      shuffleList = generateShuffleList(level);
    });
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
    if (index - level >= 0 && isFinal(shuffleList[index - level])) {
      swap(index, index - level);
    } else if (isLessThanFinal(index + level) &&
        isFinal(shuffleList[index + level])) {
      swap(index, index + level);
    } else if ((index % level != 0) && isFinal(shuffleList[index - 1])) {
      swap(index, index - 1);
    } else if (((index + 1) % level != 0) && isFinal(shuffleList[index + 1])) {
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

  bool isFinal(int number) {
    return library.isFinal(number, level);
  }

  bool isLessThanFinal(int number) {
    return library.isLessThanFinal(number, level);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
              // alignment: Alignment.topLeft,
              // padding: EdgeInsets.all(24),
              child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
                  child: const Text(
                    'Well Done!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
              const Divider()
            ],
          )),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Would you like to play this N puzzle again?',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Play again',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                startNewGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Stop',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
