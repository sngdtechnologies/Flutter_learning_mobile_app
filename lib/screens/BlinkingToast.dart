import 'package:flutter/material.dart';

class BlinkingToast {
  bool _isVisible = false;

  ///
  /// BuildContext context: le contexte à partir duquel nous devons retrouver l'Overlay
  /// WidgetBuilder externalBuilder: (obligatoire) routine externe pour créer le Widget à afficher
  /// Duration duration: (optionnel) durée au bout de laquelle le Widget sera retiré
  /// Offset position: (optionnel) position où vous voulez afficher le widget
  ///
  void show({
    BuildContext context,
    WidgetBuilder externalBuilder,
    Duration duration = const Duration(seconds: 2),
    Offset position = Offset.zero,
  }) async {
    // Empêcher d'afficher plusieurs widgets en même temps
    if (_isVisible) {
      return;
    }

    _isVisible = true;

    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => new BlinkingToastWidget(
        widget: externalBuilder(context),
        position: position,
      ),
    );
    overlayState.insert(overlayEntry);

    await new Future.delayed(duration);

    overlayEntry.remove();

    _isVisible = false;
  }
}

class BlinkingToastWidget extends StatefulWidget {
  BlinkingToastWidget({
    Key key,
    this.widget,
    this.position,
  }) : super(key: key);

  final Widget widget;
  final Offset position;

  @override
  _BlinkingToastWidgetState createState() => new _BlinkingToastWidgetState();
}

class _BlinkingToastWidgetState extends State<BlinkingToastWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: _controller, curve: new Interval(0.0, 0.5)))
      ..addListener(() {
        if (mounted) {
          setState(() {
            // Refresh
          });
        }
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse().orCancel;
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward().orCancel;
        }
      });
    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: widget.position.dy,
        left: widget.position.dx,
        child: new IgnorePointer(
          child: new Material(
            color: Colors.transparent,
            child: new Opacity(
              opacity: 1.0,
              child: widget.widget,
            ),
          ),
        ));
  }
}

// class ShowNotificationIcon {
//   void show(BuildContext context) async {
//     OverlayState overlayState = Overlay.of(context);
//     OverlayEntry overlayEntry = new OverlayEntry(builder: _build);

//     overlayState.insert(overlayEntry);

//     await new Future.delayed(const Duration(seconds: 2));

//     overlayEntry.remove();
//   }

//   Widget _build(BuildContext context) {
//     return new Positioned(
//       top: 50.0,
//       left: 50.0,
//       child: new Material(
//         color: Colors.transparent,
//         child: new Icon(Icons.warning, color: Colors.purple),
//       ),
//     );
//   }
// }
