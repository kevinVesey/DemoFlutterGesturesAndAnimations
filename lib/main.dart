import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestures and animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with
SingleTickerProviderStateMixin{
  Animation<double> animation;
  AnimationController animationController;

  int numTaps = 0;
  int numDoubleTaps = 0;
  int numLongPress = 0;
  double posX = 0.0;
  double posY = 0.0;
  double boxSize = 0.0;
  final double fullBoxSize = 150.0;
  
  @override
  initState(){
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animation.addListener(() {
      setState(() {
        boxSize = fullBoxSize * animation.value;
      });
      center(context);
    });
    //start the animation
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (posX == 0.0) {
      center(context);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Gestures and Animations!")),
      body: GestureDetector(
        onTap: (){
          setState((){
            numTaps++;
          });
        },

        onDoubleTap: (){
          setState((){
            numDoubleTaps++;
          });
        },

        onLongPress: (){
          setState((){
            numLongPress++;
          });
        },
        onVerticalDragUpdate: (DragUpdateDetails value){
          setState(() {
            //get vertical movement
            double delta = value.delta.dy;
            posY+=delta;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails value){
          setState(() {
            //get vertical movement
            double delta = value.delta.dx;
            posX+=delta;
          });
        },

          child: Stack(
        children: <Widget>[
          Positioned(
            left: posX,
            top: posY,
            child: Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          )
        ],
      )),
      bottomNavigationBar: Material(
          color: Theme.of(context).primaryColorLight,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
                "Taps: $numTaps - Double Taps: $numDoubleTaps - Long Presses $numLongPress",
                style: Theme.of(context).textTheme.headline6),
          )),
    );
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  //gets size and width of app space then divides by 2 to get center
  void center(BuildContext context) {
    posX = (MediaQuery.of(context).size.width / 2) - boxSize / 2;
    posY = (MediaQuery.of(context).size.height / 2) - boxSize / 2 - 30.0;
    setState(() {
      posX = posX;
      posY = posY;
    });
  }
}
