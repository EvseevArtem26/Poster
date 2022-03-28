import 'package:flutter/material.dart';

class NavBar extends StatefulWidget{
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{

  int selectedIndex = 2;
  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Профиль',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        label: 'Добавить пост',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'Черновики',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.ac_unit),
        label: 'Отложенные',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.gamepad),
        label: 'Статистика'
      ),
    ],
    onTap: (int index){
      setState(() {
        selectedIndex = index;
      });
    },
    );
  }
}