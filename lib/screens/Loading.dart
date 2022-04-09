import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitCircle(
          color: Colors.white,
        )
      ),
    );
  }

  void getLoaging(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: null,
        content: Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}
