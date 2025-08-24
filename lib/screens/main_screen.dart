import 'package:flutter/material.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/widgets/showDialogs/show_add_task_box.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'tasks_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 1;
  final DatabaseService _databaseService = DatabaseService.instance;

  late PageController _pageController;

  static const List<Widget> screens = <Widget>[
    TasksList(),
    Home(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;

      _pageController.animateToPage(
        index,
        duration: const Duration(microseconds: 100),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoApp'),
        backgroundColor: Colors.grey.shade400,
        elevation: 0,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
        children: screens,
      ),
      floatingActionButton: _selectIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                await showAddTaskBox(
                  context: context,
                  databaseService: _databaseService,
                  focusedDay: DateTime.now(),
                );
                setState(() {});
              },
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'TasksList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.grey.shade400,
        currentIndex: _selectIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
