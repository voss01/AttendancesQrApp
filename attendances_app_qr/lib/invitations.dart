import 'package:attendances_app_qr/checked_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'user_page.dart';
import 'user.dart';
import 'qr_sharing.dart';


class invitations extends StatefulWidget {
  @override
  State<invitations> createState() => _invitationsState();
}

class _invitationsState extends State<invitations> {
  String qrCode = 'Unknown';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CupertinoColors.lightBackgroundGray,
    appBar: AppBar(
        title: Text('Invitati'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  UserPage()),
              );
            },
          ),
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => checked(),
              ),
            );
          }, icon: Icon(Icons.list))
        ]
    ),

    body:

    StreamBuilder<List<User>>(
        stream: readUsers(),

        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Text('Something went wrong! ${snapshot}');
          }
          else if(snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(

              children: users.map(buildUser).toList(),
            );
          } else{
            return Center(child: CircularProgressIndicator());
          }
        }
    ),
    floatingActionButton: FloatingActionButton.extended(
      icon: Icon(Icons.qr_code),
      label: Text("Scan"),
      backgroundColor: CupertinoColors.systemBlue,
      onPressed: scanQrcode,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

  );


  Future<void> scanQrcode() async{
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        this.qrCode = qrCode;
        print('SCANNED QR: '+qrCode);
        final docUser = FirebaseFirestore.instance.collection('users').doc(qrCode);
        docUser.update({
          'display': 'controllato',
        });
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version';
    }

  }

  Widget buildUser(User user) =>
      Container( margin:EdgeInsets.only(bottom: 20, left:20, right:20, top:20),
          child: ListTile(
            onTap: (){
              print('open: '+user.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => qrs(user: user),
                ),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //leading: CircleAvatar(child: Text('*')),
            title: Text(user.name, style:TextStyle(fontSize: 20)),
            tileColor: Colors.white,
            leading: Icon(Icons.person, color: Colors.blue),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            trailing: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CupertinoColors.destructiveRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: Icon(Icons.delete),
                onPressed: (){
                  print('delete: '+user.id);
                  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
                  docUser.delete();
                },
              ),


            ),

          ));
  //method to return stream of list users only the ones to control with qr
  Stream<List<User>> readUsers() => FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
      snapshot.docs.map((doc)=> User.fromJson(doc.data())).where((i) => i.display=="da_controllare").toList());


}



