import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';

class Navbartitle extends StatefulWidget implements PreferredSizeWidget {
  final String titre;
  final icon;
  final TextEditingController searchview;

  Navbartitle({
    this.titre = "Accueil",
    this.icon = Icons.arrow_back,
    this.searchview,
  });

  final double _prefferedHeight = 120.0;

  @override
  _NavbartitleState createState() => _NavbartitleState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _NavbartitleState extends State<Navbartitle> {
  Color white = Colors.white;
  bool click = false;
  IconData customIcon = Icons.cancel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: (click == false)
          ? IconButton(
              icon: Icon(widget.icon, color: ArgonColors.white, size: 24.0),
              onPressed: () => (widget.icon == Icons.menu)
                  ? Scaffold.of(context).openDrawer()
                  : Navigator.pop(context))
          : Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
      title: (click == false)
          ? Text(widget.titre)
          : ListTile(
              title: TextField(
                controller: widget.searchview,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
      bottom: TabBar(
        labelColor: white,
        tabs: [
          Tab(
            iconMargin: EdgeInsets.only(top: 0.0),
            icon: Icon(
              Icons.book_rounded,
              color: Colors.redAccent,
            ),
            text: 'Cours',
          ),
          Container(
            // width: 80.0,
            child: Tab(
              iconMargin: EdgeInsets.only(top: 0.0),
              icon: Icon(
                Icons.book_rounded,
                color: Colors.brown,
              ),
              text: 'Exercices',
            ),
          ),
          Container(
            // width: 50.0,
            child: Tab(
              iconMargin: EdgeInsets.only(top: 0.0),
              icon: Icon(
                Icons.book_rounded,
                color: Colors.lightBlueAccent,
              ),
              text: 'Tp',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon((click == false) ? Icons.search : customIcon),
          onPressed: () {
            setState(() {
              if (click == false) {
                click = true;
              } else {
                click = false;
                widget.searchview.clear();
              }
            });
          },
        )
      ],
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(60),
              bottomLeft: Radius.circular(60),
            ),
          ),
    );
  }
}
