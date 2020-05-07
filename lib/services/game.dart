import 'package:property_change_notifier/property_change_notifier.dart';

class Game extends PropertyChangeNotifier<String>{
  static Game _instance;

  Game._internal();

  factory Game(){
    if(_instance == null){
      _instance = Game._internal();
    }

    return _instance;
  }

  Map<String, Map<String, dynamic>> _roundState = {
    "Team 1": {
      "Points": 50,
      "Tichu": false,
      "Grand Tichu": false,
      "Failed Tichu": false,
      "Failed Grand Tichu": false,
      "1-2": false,
    },
    "Team 2": {
      "Points": 50,
      "Tichu": false,
      "Grand Tichu": false,
      "Failed Tichu": false,
      "Failed Grand Tichu": false,
      "1-2": false,
    },
  };

  Map<String, int> _totalPoints = {
    "Team 1": 0,
    "Team 2": 0,
  };

  List<Map<String, int>> _history = [];

  void setRoundState(String team, String key, dynamic value){
    _roundState[team][key] = value;

    if(!key.contains("Points") && value){
      String otherTeam = _roundState.keys.firstWhere((String el) => !el.contains(team));
      switch(key){
        case "Tichu":
          _roundState[team]["Grand Tichu"] = false;
          _roundState[otherTeam]["Tichu"] = false;
          _roundState[otherTeam]["Grand Tichu"] = false;
          _roundState[otherTeam]["1-2"] = false;
          break;
        case "Grand Tichu":
          _roundState[team]["Tichu"] = false;
          _roundState[otherTeam]["Tichu"] = false;
          _roundState[otherTeam]["Grand Tichu"] = false;
          _roundState[otherTeam]["1-2"] = false;
          break;
        case "1-2":
          _roundState[otherTeam]["1-2"] = false;
          _roundState[otherTeam]["Tichu"] = false;
          _roundState[otherTeam]["Grand Tichu"] = false;
      }
    }

    super.notifyListeners("$team $key");
  }

  dynamic getRoundState(String team, String key) => _roundState[team][key];

  void setTotalPoints(){
    _totalPoints["Team 1"] += _calculateRoundPoints('Team 1');
    _totalPoints["Team 2"] += _calculateRoundPoints('Team 2');

    _history.add({
      "Team 1": _calculateRoundPoints('Team 1'),
      "Team 2": _calculateRoundPoints('Team 2'),
      "Round" : _history.length + 1,
    });

    _roundState = {
      "Team 1": {
        "Points": _roundState["Team 1"]["Points"],
        "Tichu": false,
        "Grand Tichu": false,
        "Failed Tichu": false,
        "Failed Grand Tichu": false,
        "1-2": false,
      },
      "Team 2": {
        "Points": _roundState["Team 2"]["Points"],
        "Tichu": false,
        "Grand Tichu": false,
        "Failed Tichu": false,
        "Failed Grand Tichu": false,
        "1-2": false,
      },
    };

    super.notifyListeners("TotalPoints");
  }

  int getTotalPoints(String team) => _totalPoints[team];

  int _calculateRoundPoints(String team){
    int points = 0;

    if(_roundState[team]["1-2"]){
      points += 200;
    }
    else{
      points += _roundState[team]["Points"];
    }

    if(_roundState[team]["Tichu"]){
      points += 100;
    }

    if(_roundState[team]["Grand Tichu"]){
      points += 200;
    }

    if(_roundState[team]["Failed Tichu"]){
      points -= 100;
    }

    if(_roundState[team]["Failed Grand Tichu"]){
      points -= 200;
    }

    return points;
  }

  List<Map<String, int>> get history => _history;
}