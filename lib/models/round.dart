class Round{
  int _number;
  String _team1Name;
  String _team2Name;
  int _team1Score;
  int _team2Score;

  Map<String, Map<String, dynamic>> _roundState;

  Round(this._number, this._team1Name, this._team2Name){

    _roundState = {
      _team1Name: {
        "Points": 50,
        "Tichu": false,
        "Grand Tichu": false,
        "Failed Tichu": false,
        "Failed Grand Tichu": false,
        "1-2": false,
      },
      _team2Name: {
        "Points": 50,
        "Tichu": false,
        "Grand Tichu": false,
        "Failed Tichu": false,
        "Failed Grand Tichu": false,
        "1-2": false,
      },
    };
  }

  Round.fromMap(Map<String, dynamic> roundMap){
    _number = roundMap["number"];
    _team1Name = roundMap["team1Name"];
    _team2Name = roundMap["team2Name"];
    _team1Score = roundMap["team1Score"];
    _team2Score = roundMap["team2Score"];
    _roundState = {...roundMap["roundState"]};
  }

  Map<String, dynamic> toMap() => {
    "number": _number,
    "team1Name": _team1Name,
    "team2Name": _team2Name,
    "team1Score": _team1Score,
    "team2Score": _team2Score,
    "roundState": _roundState,
  };

  int get number => _number;

  int get team2Score => _team2Score;

  int get team1Score => _team1Score;

  set team1Name(String value) {
    _roundState = {
      value: { ..._roundState[_team1Name] },
      _team2Name: { ..._roundState[_team2Name] },
    };

    _team1Name = value;

  }

  set team2Name(String value) {
    _roundState = {
      _team1Name: { ..._roundState[_team1Name] },
      value: { ..._roundState[_team2Name] },
    };

    _team2Name = value;
  }

  void setRoundState(int teamNumber, String key, dynamic value){
    String team = teamNumber == 1 ? _team1Name : _team2Name;
    String otherTeam = teamNumber == 1 ? _team2Name : _team1Name;

    _roundState[team][key] = value;

    if(!key.contains("Points") && value){
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
  }

  dynamic getRoundState(int teamNumber, String key) =>
      _roundState[teamNumber == 1 ? _team1Name : _team2Name][key];

  set state(Map<String, Map<String, dynamic>> roundState) =>
      this._roundState = roundState;

  Map<String, Map<String, dynamic>> get state => _roundState;

  void calculateScores(){
    _team1Score = _calculateRoundPoints(1);
    _team2Score = _calculateRoundPoints(2);
  }

  int _calculateRoundPoints(int teamNumber){
    String team = teamNumber == 1 ? _team1Name : _team2Name;
    String enemyTeam = teamNumber == 1 ? _team2Name : _team1Name;

    int points = 0;

    if(_roundState[team]["1-2"]){
      points += 200;
    }
    else{
      if(!_roundState[enemyTeam]["1-2"]){
        points += _roundState[team]["Points"];
      }
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
}