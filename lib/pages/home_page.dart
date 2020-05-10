import 'package:flutter/material.dart';
import 'package:tichucounter/models/game.dart';
import 'package:tichucounter/services/data.dart';
import 'package:tichucounter/services/storage.dart';
import 'package:tichucounter/widgets/round_as_text.dart';
import 'package:tichucounter/widgets/team_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Data data = Data();
  final TextEditingController nameController = TextEditingController();
  final key = GlobalKey<ScaffoldState>();
  bool _loading = true;

  @override
  void initState() {
    data.addListener((){
      setState(() {});
    }, ["TotalPoints Team1 Team2 Points"]);

    Storage.fetchGame().then((game){
      setState(() {
        if(game != null){
          loadGameDialog(game);
        }
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Tichu Counter'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            iconSize: 25.0,
            onPressed: (){
              Storage.storeGame(data.game).whenComplete((){
                key.currentState.showSnackBar(SnackBar(
                  elevation: 10.0,
                  content: Text("Game Saved"),
                  duration: Duration(seconds: 3),
                ));
              });
            },
          )
        ],
        centerTitle: true,
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) : _mainWidget(),
    );
  }

  Widget _mainWidget(){
    return Column(
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
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
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
          height: MediaQuery.of(context).size.height / 16,
          width: MediaQuery.of(context).size.width / 3,
          child: RaisedButton(
            color: Colors.blue[300],
            onPressed: (){
              if(Data.canCalculate){
                data.setTotalPoints(false);
              }
            },
            child: Text("Calculate Round",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 16,
          child: RaisedButton(
            color: Colors.yellow[300],
            onPressed: data.game.rounds.length > 1
                ? (){
                    if(Data.canCalculate){
                      data.setTotalPoints(true);
                    }
                  }
                : null,
            child: Text("Edit Last Round",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 16,
          child: RaisedButton(
            color: Colors.red[300],
            onPressed: (){ newGameDialog(); },
            child: Text("New Game",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
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

  void loadGameDialog(Game game){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Load Game"),
        content: Text("A game has previously been saved. Do you want to continue this game or start a new one?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Start new game"),
            onPressed: (){Navigator.pop(context, false);},
          ),
          FlatButton(
            child: Text("Continue saved game"),
            onPressed: (){Navigator.pop(context, true);},
          ),
        ],
        elevation: 25.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      barrierDismissible: false,
    ).then((value){
      setState(() {
        if(value) {
          data.game = game;
        }
      });
    }).catchError((error){ return null; });
  }
}
