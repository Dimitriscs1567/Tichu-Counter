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

  void setRoundState(String team, String key, dynamic value){
    _roundState[team][key] = value;

    if(!key.contains("Points") && value){
      String otherTeam = _roundState.keys.firstWhere((String el) => !el.contains(team));
      switch(key){
        case "Tichu":
          _roundState[team]["Grand Tichu"] = false;
          _roundState[otherTeam]["Tichu"] = false;
          _roundState[otherTeam]["Grand Tichu"] = false;
          break;
        case "Grand Tichu":
          _roundState[team]["Tichu"] = false;
          _roundState[otherTeam]["Tichu"] = false;
          _roundState[otherTeam]["Grand Tichu"] = false;
          break;
        case "1-2":
          _roundState[otherTeam]["1-2"] = false;
      }
    }

    super.notifyListeners("$team $key");
  }

  dynamic getRoundState(String team, String key) => _roundState[team][key];
}