import 'package:flutter/material.dart';
import 'package:premiere/VeryfyConnection.dart';
import 'package:premiere/models/chat_params.dart';
import 'package:premiere/screens/Chat/ChatPage.dart';
import 'package:premiere/screens/Chat/HomePage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return MaterialPageRoute(builder: (context) => VeryfyConnection());
        break;
      case '/home_chat':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(curve: Curves.ease, parent: animation);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }
        );
        break;
      case '/chat':
        var arguments = settings.arguments;
        if (arguments != null) {
          return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChatPage(chatParams : arguments as ChatParams),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                animation = CurvedAnimation(curve: Curves.ease, parent: animation);
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              }
          );
        } else {
          return pageNotFound();
        }
        break;
      default:
        return pageNotFound();
    }
  }

  static MaterialPageRoute pageNotFound() {
    return MaterialPageRoute(
        builder: (context) =>
            Scaffold(
                appBar: AppBar(title: Text("Error"), centerTitle: true),
                body: Center(
                  child: Text("Page not found"),
                )
            )
    );
  }
}