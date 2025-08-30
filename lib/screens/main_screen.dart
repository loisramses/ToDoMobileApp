// main_screen.dart
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
  final GlobalKey<TasksListState> tasksListKey = GlobalKey<TasksListState>();
  final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>();
  bool _showScrollButton = false;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectIndex);
    screens = <Widget>[
      TasksList(key: tasksListKey, onScroll: _onTasksListScroll),
      Home(
        key: homeKey,
      ),
      const Settings(),
    ];
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
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    });
  }

  void _onTasksListScroll(bool show) {
    setState(() {
      _showScrollButton = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? floatingActionButton;

    if (_selectIndex == 0) {
      if (_showScrollButton) {
        floatingActionButton = FloatingActionButton(
          onPressed: () {
            tasksListKey.currentState?.scrollToBottom();
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
        );
      } else {
        floatingActionButton = null;
      }
    } else if (_selectIndex == 1) {
      floatingActionButton = FloatingActionButton(
        onPressed: () async {
          await showAddTaskBox(
            context: context,
            databaseService: _databaseService,
            focusedDay: homeKey.currentState?.focusedDay ?? DateTime.now(),
          );
          homeKey.currentState?.refreshTasks();
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoApp'),
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
      floatingActionButton: floatingActionButton,
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
