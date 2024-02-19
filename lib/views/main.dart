import 'package:first_flutter_app/config/theme/app_theme.dart';
import 'package:first_flutter_app/views/films_list/films_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  var showAppbar = true;

  void setAppbarVisibility(bool visible) {
    if (showAppbar != visible) {
      showAppbar = visible;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'PelisRegister',
        theme: AppTheme().theme(),
        home: const BottomTabBarWidget(),
      ),
    );
  }
}

class BottomTabBarWidget extends StatefulWidget {
  const BottomTabBarWidget({super.key});

  @override
  State<BottomTabBarWidget> createState() => _BottomTabBarWidget();
}

class _BottomTabBarWidget extends State<BottomTabBarWidget> {

  int _selectedIndex = 1;
  static const List _tabPages = [
    Text('I travel by Car'),
    FilmsListView(),
    Text('I like to ride my bycycle'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AnimatedAppBar(showAppBar: appState.showAppbar,),

      body: Center(
        child: _tabPages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Mi lista'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

}

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget { //implements PreferredSizeWidget
  const AnimatedAppBar({super.key, required this.showAppBar});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: showAppBar ? 1.4*kToolbarHeight : 0,
      //adjust your duration
      duration: const Duration(milliseconds: 400),
      child: AppBar(
        title: Text("PelisRegister"),
        centerTitle: true,
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}