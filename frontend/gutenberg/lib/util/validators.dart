

import 'package:flutter/material.dart';

class SignUpValidator{

  static bool validate(BuildContext context, String login, String password, String confirmPassword, String email){
    return validateLogin(context, login) && validatePassword(context, password, confirmPassword) && validateEmail(context, email);
  }

  static bool validateLogin(BuildContext context, String login){
    if(login.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please enter your name"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else{
      return true;
    }
  }

  static bool validatePassword(BuildContext context, String password, String confirmPassword){
    if(password.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please enter your password"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(confirmPassword.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please confirm your password"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(password != confirmPassword){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Password are not the same"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else{
      return true;
    }
  }

  static bool validateEmail(BuildContext context, String email){
    if(email.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please enter your email"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else{
      return true;
    }
  }

}