import 'package:tichucounter/models/round.dart';

class Game{

  String _name;
  String _team1Name;
  String _team2Name;
  List<Round> _rounds = [];
  Map<String, int> _totalPoints;

  Game(this._name, this._team1Name, this._team2Name, int points1, int points2){
    _totalPoints = {
      _team1Name: 0,
      _team2Name: 0,
    };

    _addNewRound(points1: points1, points2: points2);
  }

  Game.fromMap(Map<String, dynamic> gameMap){
    List<Round> tempRounds = [];
    (gameMap["rounds"] as List).forEach((round) => tempRounds.add(Round.fromMap(round)));

    _name = gameMap["name"];
    _team1Name = gameMap["team1Name"];
    _team2Name = gameMap["team2Name"];
    _rounds = tempRounds;
    _totalPoints = {...gameMap["totalPoints"]};
  }

  Map<String, dynamic> toMap(){
    List<Map<String, dynamic>> roundsMap = [];

    _rounds.forEach((round){
      roundsMap.add(round.toMap());
    });

    return {
      "name": _name,
      "team1Name": _team1Name,
      "team2Name": _team2Name,
      "rounds": roundsMap,
      "totalPoints": _totalPoints,
    };
  }

  set name(String name) => _name = name;

  String get name => _name;

  String get team1Name => _team1Name;

  String get team2Name => _team2Name;

  List<Round> get rounds => _rounds;

  List<Round> getHistoryRounds() => _rounds.sublist(0, _rounds.length - 1);

  Map<String, int> get totalPoints => _totalPoints;

  Round getCurrentRound() => _rounds.last;

  Round getPreviousRound() => _rounds[_rounds.length - 2];

  void endRound(bool edit){
    if(edit){
      _totalPoints[_team1Name] -= getPreviousRound().team1Score;
      _totalPoints[_team2Name] -= getPreviousRound().team2Score;

      rounds.last.calculateScores();
      _totalPoints[_team1Name] += _rounds.last.team1Score;
      _totalPoints[_team2Name] += _rounds.last.team2Score;

      getPreviousRound().state = {
        _team1Name: {..._rounds.last.state[_team1Name]},
        _team2Name: {..._rounds.last.state[_team2Name]},
      };
      getPreviousRound().calculateScores();
      _rounds.last.cleanState();
    }
    else{
      rounds.last.calculateScores();
      _totalPoints[_team1Name] += _rounds.last.team1Score;
      _totalPoints[_team2Name] += _rounds.last.team2Score;

      _addNewRound();
    }
  }

  void _addNewRound({int points1, int points2}){
    _rounds.add(Round(
      _rounds.length + 1,
      _team1Name,
      _team2Name,
    ));
  }

  void setNewTeamName(int team, String name){
    if(team == 1){
      _totalPoints = {
        name : _totalPoints[_team1Name],
        _team2Name: _totalPoints[_team2Name],
      };
      _team1Name = name;

      for(Round round in _rounds){
        round.team1Name = name;
      }
    }
    else{
      _totalPoints = {
        _team1Name : _totalPoints[_team1Name],
        name: _totalPoints[_team2Name],
      };
      _team2Name = name;
      for(Round round in _rounds){
        round.team2Name = name;
      }
    }
  }
}