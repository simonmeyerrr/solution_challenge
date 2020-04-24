import 'package:flutter/material.dart';
import 'package:solution_challenge/services/authentication.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({this.auth, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Color headerColor = Colors.blue;
  String _userName = "";

  signOut() async {
    try {
      await this.widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  getUserName() async {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userName = user?.displayName;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Handle dark mode
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (isDark) {
      headerColor = Colors.blueAccent;
    }
    getUserName();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Google City Art',
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
            leading: Icon(Icons.account_box),
            title: Text("Welcome " + _userName),
            onTap: () => {},
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