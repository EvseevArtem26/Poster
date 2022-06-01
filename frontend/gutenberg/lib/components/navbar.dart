import 'package:flutter/material.dart';

class NavBar extends StatefulWidget{
  const NavBar({Key? key, required this.initialIndex}) : super(key: key);
  final int initialIndex;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{

  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          )
        ),
      ),
      child: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        elevation: 0,
        
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Добавить пост',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_edu),
          label: 'Черновики',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Опубликованные',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.hourglass_bottom),
          label: 'Отложенные'
        ),
      ],
      onTap: (int index){
        setState(() {
          selectedIndex = index;
          switch(index){
            case 0:  Navigator.pushReplacementNamed(context, '/home');
            break;
            case 1:  Navigator.pushReplacementNamed(context, '/add');
            break;
            case 2:  Navigator.pushReplacementNamed(context, '/drafts');
            break;
            case 3:  Navigator.pushReplacementNamed(context, '/published');
            break;
            case 4:  Navigator.pushReplacementNamed(context, '/delayed');
            break;
          }
        });
      },
      ),
    );
  }
}