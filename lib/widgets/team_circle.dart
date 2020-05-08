import 'package:flutter/material.dart';
import 'package:tichucounter/services/data.dart';
import 'package:tichucounter/services/utils.dart';
import 'package:tichucounter/widgets/circle_button.dart';

class TeamCircle extends StatefulWidget {

  final int team;
  final int enemyTeam;

  TeamCircle({@required this.team, @required this.enemyTeam});

  @override
  _TeamCircleState createState() => _TeamCircleState();
}

class _TeamCircleState extends State<TeamCircle> {
  final Data data = Data();
  final FixedExtentScrollController scrollController = FixedExtentScrollController(
    initialItem: 15
  );

  @override
  void initState() {

    data.addListener((String property){
      bool onEnemy = property.contains("Team${widget.enemyTeam}");

      if(property.contains("Points") && onEnemy){
        int points = 100 - data.game.getCurrentRound().getRoundState(widget.enemyTeam, 'Points');

        scrollController.animateToItem(
          Utils.pointsToIndex(points),
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      }
      else{
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _topHalf(),
              _middleHalf(),
              _bottomHalf(),
            ],
          ),
          _center(),
        ],
      ),
    );
  }

  Widget _topHalf(){
    return Expanded(
      flex: 3,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: CircleButton(
                  team: widget.team,
                  horizontal: false,
                  text: 'Tichu',
                  color: Colors.green,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(1000)),
                )
            ),
            Expanded(
              child: CircleButton(
                team: widget.team,
                horizontal: false,
                text: 'Failed Tichu',
                borderRadius: BorderRadius.only(topRight: Radius.circular(1000)),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _middleHalf(){
    return Expanded(
      flex: 3,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: CircleButton(
                  team: widget.team,
                  horizontal: true,
                  text: '1-2',
                  color: Colors.blue,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(0.1)),
                )
            ),
            Expanded(
              child: CircleButton(
                team: widget.team,
                horizontal: true,
                text: '1-2',
                borderRadius: BorderRadius.horizontal(right: Radius.circular(0.1)),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomHalf(){
    return Expanded(
      flex: 3,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: CircleButton(
                team: widget.team,
                horizontal: false,
                text: 'Failed Grand Tichu',
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1000)),
                color: Colors.red,
              ),
            ),
            Expanded(
              child: CircleButton(
                team: widget.team,
                horizontal: false,
                text: 'Grand Tichu',
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(1000)),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _center(){
    double size = MediaQuery.of(context).size.width / 3.5;

    return Center(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: Colors.brown[300],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll){
              overscroll.disallowGlow();
              return true;
            },
            child: ListWheelScrollView(
              controller: scrollController,
              itemExtent: size / 2,
              diameterRatio: 1.2,
              onSelectedItemChanged: (index){
                int points = Utils.indexToPoints(index);
                if(points != data.game.getCurrentRound().getRoundState(widget.team, "Points")){
                  data.setRoundState(widget.team, "Points", points);
                }
              },
              children: List.generate(31, (index) => Utils.indexToPoints(index)).map((number){
                return Center(
                  child: Text(number.toString(),
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                );
              },).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
