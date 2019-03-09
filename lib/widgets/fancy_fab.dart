import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final void Function() onPressed;
  final String tooltip;
  final Icon icon;
  final ColorTween buttonColor;
  final List<FloatingActionButton> children;

  FancyFab({
    this.onPressed,
    this.tooltip,
    this.icon = const Icon(Icons.list),
    this.buttonColor,
    this.children,
  });

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = widget.buttonColor?? ColorTween(
      //begin: Colors.blue,
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /*Extremely sketchy but at least works*/
  animate() {
    if (!isOpened) {
      _animationController.forward()
          .whenComplete(() => setState(() {
        isOpened = !isOpened;
      }),);
    } else {
      _animationController.reverse();
      setState(() {
        isOpened = !isOpened;
      });
    }

  }

  Widget toggle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: _buttonColor.value,
            /*If widget has onPressed the execute the function, otherwise expand the widget*/
            onPressed:widget.onPressed != null ? widget.onPressed : animate,
            tooltip: widget.tooltip,//'Toggle',
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animateIcon,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int test = widget.children.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List<Widget>.from(
          widget.children.map((fab){
            return Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * test--,
                  0.0,
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child:  isOpened ? Chip(
                          label: Text(
                            "prova",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold),
                          ),
                        ) : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: fab,
                      )
                    ],
                  ),
                )
            );
          }).toList()
      )..add(toggle())
    );
  }
}