import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';
// import 'package:argon_flutter/constants/Theme.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal(
      {this.title = "titre",
      this.cta = "",
      this.chemin = "",
      this.evaluation = "",
      this.anAcad = "",
      this.img = 'assets/img/imgpdf1.jpg',
      this.tap = defaultFunc});

  final String cta;
  final String chemin;
  final String img;
  final Function tap;
  final String title;
  final String evaluation;
  final String anAcad;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.17,
        child: GestureDetector(
          onTap: tap,
          child: Card(
            elevation: 0.6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      // height: 20.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0)),
                          image: DecorationImage(
                            image: AssetImage(img),
                          ))),
                ),
                Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(evaluation,
                              style: TextStyle(
                                  color: ArgonColors.header, fontSize: 12)),
                          Text(title,
                              style: TextStyle(
                                  color: ArgonColors.header, fontSize: 12)),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(anAcad,
                                style: TextStyle(
                                    color: ArgonColors.header, fontSize: 12)),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
