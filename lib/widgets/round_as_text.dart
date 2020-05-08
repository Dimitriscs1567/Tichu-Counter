import 'package:flutter/material.dart';
import 'package:tichucounter/models/round.dart';

class RoundAsText extends StatelessWidget {

  final Round round;

  RoundAsText({@required this.round});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: Row(
        children: <Widget>[
          RichText(
            text: round.number < 10 ? TextSpan(
              text:'0',
              style: TextStyle(fontSize: 20.0, color: Colors.white.withOpacity(0.0)),
              children: <TextSpan>[
                TextSpan(
                  text: round.number.toString() + '.',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ],
            ):
            TextSpan(
              text: round.number.toString() + '.',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ) ,
          ),
          Expanded(
            child: _getScoreText(1),
          ),
          Expanded(
            child: _getScoreText(2),
          ),
        ],
      ),
    );
  }

  Widget _getScoreText(int team){
    return RichText(
      text: TextSpan(
          text: team == 1 ? round.team1Score.toString() : round.team2Score.toString(),
          style: TextStyle(fontSize: 20.0, color: Colors.black),
          children: <TextSpan>[
            round.getRoundState(team, "Tichu")
                ? TextSpan(text: " T", style: _getStyle(true, false),)
                : TextSpan(text: ""),
            round.getRoundState(team, "Grand Tichu")
                ? TextSpan(text: " G", style: _getStyle(true, false),)
                : TextSpan(text: ""),
            round.getRoundState(team, "Failed Tichu")
                ? TextSpan(text: " T", style: _getStyle(false, false),)
                : TextSpan(text: ""),
            round.getRoundState(team, "Failed Grand Tichu")
                ? TextSpan(text: " G", style: _getStyle(false, false),)
                : TextSpan(text: ""),
            round.getRoundState(team, "1-2")
                ? TextSpan(text: " 1-2", style: _getStyle(true, true),)
                : TextSpan(text: ""),
          ]
      ),
      textAlign: TextAlign.center,
    );
  }

  TextStyle _getStyle(bool win, bool oneTwo){
    Color color = win ? Colors.green[700] : Colors.red[700];
    if(oneTwo) color = Colors.blue[700];

    return TextStyle(
      fontSize: 20.0,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}
