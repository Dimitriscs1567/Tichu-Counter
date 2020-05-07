import 'package:flutter/material.dart';
import 'package:tichucounter/services/game.dart';

class CircleButton extends StatelessWidget {
  final Game game = Game();
  final Color color;
  final BorderRadius borderRadius;
  final String text;
  final bool horizontal;
  final String team;
  bool selected;
  String position;

  CircleButton({
    @required this.color,
    @required this.borderRadius,
    @required this.text,
    @required this.team,
    @required this.horizontal,
  }){
    position = borderRadius.toString().split('(')[1].split(':')[0];
  }

  @override
  Widget build(BuildContext context) {
    selected = game.getRoundState(team, text);
    double angle = 0.8;
    Offset offset;
    double offsetValue = MediaQuery.of(context).size.width / 15;

    switch(position){
      case 'topLeft':
        angle = horizontal ? 0.0 : -angle;
        offset = Offset(horizontal ? -offsetValue : 0, 0);
        break;
      case 'topRight':
        angle = horizontal ? 0.0 : angle;
        offset = Offset(horizontal ? offsetValue : 0, 0);
        break;
      case 'bottomRight':
        offset = Offset(0, 0);
        angle = -angle;
        break;
      case 'bottomLeft':
        offset = Offset(0, 0);
        angle = angle;
        break;
    }

    return GestureDetector(
      onTap: (){
        game.setRoundState(team, text, !selected);
      },
      child: Opacity(
        opacity: selected ? 1.0 : 0.3,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: color,
          ),
          child: Transform.translate(
            offset: offset,
            child: Transform.rotate(
              angle: angle,
              child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: horizontal ? 16.0: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
