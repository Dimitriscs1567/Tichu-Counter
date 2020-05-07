import 'package:flutter/material.dart';
import 'package:tichucounter/services/game.dart';
import 'package:tichucounter/widgets/team_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Game game = Game();

  @override
  void initState() {
    game.addListener((){
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
            child: _teamsInfo(),
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
                    child: RaisedButton(
                      color: Colors.blue[300],
                      onPressed: (){ game.setTotalPoints(); },
                      child: Text("Calculate Round"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.center,
                    child: Text("Rounds",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: game.history.reversed.map((round){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                          child: Row(
                            children: <Widget>[
                              RichText(
                                text: round["Round"] < 10 ? TextSpan(
                                  text:'0',
                                  style: TextStyle(fontSize: 20.0, color: Colors.white.withOpacity(0.0)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: round["Round"].toString() + '.',
                                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                                    ),
                                  ],
                                ):
                                TextSpan(
                                  text: round["Round"].toString() + '.',
                                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                                ) ,
                              ),
                              Expanded(
                                child: Text(round["Team 1"].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Expanded(
                                child: Text(round["Team 2"].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      },).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamsInfo(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Team 1',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(game.getTotalPoints("Team 1").toString(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Team 2',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(game.getTotalPoints("Team 2").toString(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _teamActions(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TeamCircle(
            team: "Team 1",
            enemyTeam: "Team 2",
          ),
        ),
        Expanded(
          child: TeamCircle(
            team: "Team 2",
            enemyTeam: "Team 1",
          ),
        ),
      ],
    );
  }
}
