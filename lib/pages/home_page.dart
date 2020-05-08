import 'package:flutter/material.dart';
import 'package:tichucounter/services/data.dart';
import 'package:tichucounter/widgets/round_as_text.dart';
import 'package:tichucounter/widgets/team_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Data data = Data();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    data.addListener((){
      setState(() {});
    }, ["TotalPoints"]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Tichu Counter'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                _teamsInfo(1),
                _teamsInfo(2),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _teamActions(),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30.0),
                    child: _buttonRow(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.center,
                    child: Text("Rounds",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  _history(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamsInfo(int teamNumber){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){ changeNameDialog(teamNumber); },
            child: Text(teamNumber == 1 ? data.game.team1Name : data.game.team2Name,
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text( teamNumber == 1
              ? data.game.totalPoints[data.game.team1Name].toString()
              : data.game.totalPoints[data.game.team2Name].toString(),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _teamActions(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TeamCircle(
            team: 1,
            enemyTeam: 2,
          ),
        ),
        Expanded(
          child: TeamCircle(
            team: 2,
            enemyTeam: 1,
          ),
        ),
      ],
    );
  }

  Widget _history() {
    return Expanded(
      child: ListView(
        children: data.game.getHistoryRounds().reversed.map((round){
          return RoundAsText(round: round,);
        },).toList(),
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: RaisedButton(
            color: Colors.blue[300],
            onPressed: (){ data.setTotalPoints(false); },
            child: Text("Calculate Round",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: RaisedButton(
            color: Colors.yellow[300],
            onPressed: data.game.rounds.length > 1
                ? (){ data.setTotalPoints(true); }
                : null,
            child: Text("Edit Last Round",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: RaisedButton(
            color: Colors.red[300],
            onPressed: (){ newGameDialog(); },
            child: Text("New Game"),
          ),
        ),
      ],
    );
  }

  void newGameDialog(){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Start a new game"),
        content: Text("Are you sure you want to start a new game?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: (){Navigator.pop(context, false);},
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: (){Navigator.pop(context, true);},
          ),
        ],
        elevation: 25.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      barrierDismissible: true,
    ).then((value){
      if(value){
        setState(() {
          data.newGame();
        });
      }
    }).catchError((error){ return null; });
  }

  void changeNameDialog(int team){
    nameController.text = team == 1 ? data.game.team1Name : data.game.team2Name;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(team == 1 ? "Change first team's name" : "Change second team's name"),
        content: TextFormField(
          controller: nameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Team $team name",
            labelStyle: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: (){Navigator.pop(context, nameController.text);},
          ),
        ],
        elevation: 25.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      barrierDismissible: true,
    ).then((value){
      if(value.trim().isNotEmpty){
        setState(() {
          data.game.setNewTeamName(team, value);
        });
      }
    }).catchError((error){ return null; });
  }
}
