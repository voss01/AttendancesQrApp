import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr_sharing.dart';
import 'user.dart';
class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

  class _UserPageState extends State<UserPage>{
    final controllerName = TextEditingController();
    @override
    Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ), //App bar
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            //fields
            TextField(
              controller: controllerName,
              decoration: decoration('Name'),
            ),
            const SizedBox(height:24),
            //button
            const SizedBox(height: 32),

            ElevatedButton(
              child: Text('Create'),
              onPressed:(){
                //create new user
                final user = User(
                  name: controllerName.text,
                  display: 'da_controllare',
                ); //User

                //send to firebase
                createUser(user);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => qrs(user: user),
                  ),
                );
              },
            ),

          ],
        ),
    );

    InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );


    Future createUser(User user) async {
      final docUser = FirebaseFirestore.instance.collection('users').doc();
      user.id = docUser.id;
      final json = user.toJson();
      await docUser.set(json);

    }
}

