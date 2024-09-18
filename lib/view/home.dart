import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:movielist/view/mostPopularMovies.dart';
import 'package:movielist/view/nowPlayingMovies.dart';
import 'package:movielist/view/ProfileView.dart';
import 'package:movielist/view/topRatedMovies.dart';
import 'package:movielist/view/userFavourites.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    topRatedMovies(),
    nowPlayingMovies(),
    mostPopularMovies(),
    userFavourites(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: Colors.white,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        items: <Widget>[
          Text(
            'Top Rated',
            style: TextStyle(color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
          ),
          Text(
            'Now Playing',
            style: TextStyle(color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
          ),
          Text(
            'Most Popular',
            style: TextStyle(color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
          ),
          Text(
            'User Fav',
            style: TextStyle(color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
          ),
          Text(
            'Profile',
            style: TextStyle(color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}