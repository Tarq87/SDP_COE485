import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsFourPage extends StatefulWidget {
  @override
  _SettingsFourPageState createState() => _SettingsFourPageState();
}

class _SettingsFourPageState extends State<SettingsFourPage> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[],
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            ChangePassword(context, "Change password"),
            ChangePassword(context, "Content settings"),
            ChangePassword(context, "Social Media"),
            ChangePassword(context, "Language"),
            ChangePassword(context, "Privacy and Policy"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.privacy_tip,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Privacy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share Location',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                        activeColor: Colors.blue,
                        value: value,
                        onChanged: (bool newValue) {
                          setState(() {
                            value = newValue;
                          });
                        }))
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Lagout",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector ChangePassword(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Enter Your New Password"),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.security),
                        hintText: 'Password',
                      ),
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
