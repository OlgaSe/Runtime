final List<int> timeList = generateMinutesList();

List<int> generateMinutesList() {
  List<int> res = [];
  for (int i=6 * 60; i<= 21* 60; i+=15) {
    res.add(i);
  }

  return res;
}

