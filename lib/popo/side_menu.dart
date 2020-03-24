import 'package:flutter/material.dart';
import 'package:solution_challenge/services/authentication.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({this.auth, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;


  Color headerColor = Colors.blue;

  signOut() async {
    try {
      await this.auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Handle dark mode
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (isDark) {
      headerColor = Colors.blueAccent;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: headerColor,
                /*image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg')
                )*/
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              Navigator.pop(context),
              signOut()
            },
          ),
        ],
      ),
    );
  }
}