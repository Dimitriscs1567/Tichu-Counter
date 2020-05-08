import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:tichucounter/models/game.dart';

class Data extends PropertyChangeNotifier<String>{
  static Data _instance;
  static Game _game;

  Data._internal();

  factory Data(){
    if(_instance == null){
      _instance = Data._internal();
      _game = Game("", "Team 1", "Team 2", 50, 50);
    }

    return _instance;
  }

  Game get game => _game;

  void setRoundState(int teamNumber, String key, dynamic value){
    _game.getCurrentRound().setRoundState(teamNumber, key, value);
    super.notifyListeners("Team$teamNumber $key");
  }

  void setTotalPoints(bool edit){
    _game.endRound(edit);
    super.notifyListeners("TotalPoints");
  }

  void newGame(){
    _game = Game(
      "",
      _game.team1Name,
      _game.team2Name,
      _game.getCurrentRound().getRoundState(1, "Points"),
      _game.getCurrentRound().getRoundState(2, "Points"),
    );
  }
}