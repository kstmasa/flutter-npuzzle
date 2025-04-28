class MyLibrary {
  bool isFinal(int number, int level) {
    return number == (level * level - 1);
  }

  bool isLessThanFinal(int number, int level) {
    return number <= (level * level - 1);
  }
}
