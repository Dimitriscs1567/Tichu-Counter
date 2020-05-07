class Utils {

  static int pointsToIndex(int points){
    return (points/5 + 5).floor();
  }

  static int indexToPoints(int index){
    return (index*5 - 25);
  }
}