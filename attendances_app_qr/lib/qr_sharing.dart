
import 'package:attendances_app_qr/invitations.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'user.dart';
import 'user.dart';
import 'user_page.dart';

class qrs extends StatefulWidget {
  //require user arg
  const qrs({super.key, required this.user});
  // Declare a field that holds the User.
  final User user;
  @override
  State<qrs> createState() => qr_sharing();
}

class qr_sharing extends State<qrs>{

  final controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Share QR code'),
    ), //App bar
    body: ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        //fields
        const SizedBox(height:24),
        //button
        const SizedBox(height: 32),
        BarcodeWidget(data: widget.user.id ?? 'Default', barcode: Barcode.qrCode(), color:CupertinoColors.systemBlue),
        Text(widget.user.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 25),),

        ElevatedButton(
          child: Text('Fine'),
          onPressed:(){
            Navigator.popUntil(context, ModalRoute.withName('/'));
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

