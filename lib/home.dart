import 'package:flutter/material.dart';
import 'package:isolates_test/navigation_icon_view.dart';
import 'package:isolates_test/test_page.dart';

enum Sections { isolate, compute }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  Map<Sections, GlobalKey<NavigatorState>> navigatorKeys = {
    Sections.isolate: GlobalKey<NavigatorState>(debugLabel: 'isolate'),
    Sections.compute: GlobalKey<NavigatorState>(debugLabel: 'compute'),
  };

   BottomNavigationBar bottomNavigationBar() {
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
          icon: Icon(Icons.home),
          title: 'Isolates',
          color: Colors.blue[700],
          vsync: this),
      NavigationIconView(
          icon: Icon(Icons.home),
          title: 'Compute',
          color: Colors.blue[700],
          vsync: this)
    ];

    _navigationViews[_currentIndex].controller.value = 1.0;

    return BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>(
              (NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      onTap: _onTap,
      type: _type,
    );
  }

  void _onTap(int index) {
    setState(() {
      _navigationViews[_currentIndex].controller.reverse();
      _currentIndex = index;
      _navigationViews[_currentIndex].controller.forward();
    });
  }

  Sections _sectionForIndex(int index) {
    switch (index) {
      case 0:
        return Sections.isolate;
        break;
      case 1:
        return Sections.compute;
        break;
    }
  }

  Widget _bodyForSection(Sections section) {
    switch (section) {
      case Sections.isolate:
        return TestPage(false);
        break;
      case Sections.compute:
        return TestPage(true);
        break;
    }
  }

  Widget _buildOffstageNavigator(Sections section) {
    return Offstage(
      offstage: _sectionForIndex(_currentIndex) != section,
      child: Navigator(
        key: navigatorKeys[section],
        initialRoute: '/',
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => _bodyForSection(section)
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => navigatorKeys[_sectionForIndex(_currentIndex)].currentState.maybePop(),
      child: Container(
        color: Colors.blue[700],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                _buildOffstageNavigator(Sections.isolate),
                _buildOffstageNavigator(Sections.compute)
              ],
            ),
            bottomNavigationBar: bottomNavigationBar(),
          ),
        ),
      ),
    );
  }
}