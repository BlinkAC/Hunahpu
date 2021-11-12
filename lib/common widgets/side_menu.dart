import 'package:cursoflutter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenu extends StatefulWidget {
  SideMenu({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  
  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user  = FirebaseAuth.instance.currentUser;
    var userid = user!.displayName;
    var userEmail = user.email;
    var profileImg = user.photoURL;
    if(userid==null && userEmail==null ){
      userid = 'Invitado';
      userEmail = 'Invitado';
      profileImg = 'https://f0.pngfuel.com/png/136/22/profile-icon-illustration-user-profile-computer-icons-girl-customer-avatar-png-clip-art.png';
    }
    return Drawer(
      
      child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(userid.toString(), style: TextStyle(color: Colors.white),),
          accountEmail: Text(userEmail.toString(), style: TextStyle(color: Colors.white),),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image(
                image: NetworkImage(
                    profileImg.toString() ),
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            image: DecorationImage(
                image: AssetImage('assets/back_image.jpg'),
                fit: BoxFit.cover),
          ),
        ),
        ListTile(
            leading: Icon(FontAwesomeIcons.list),
            title: Text('Mis listas'),
            onTap: () {}),
            Divider(),
        ListTile(
            leading: Icon(FontAwesomeIcons.questionCircle),
            title: Text('Ayuda'),
            onTap: () {}),
            Divider(),
        ListTile(
            leading: Icon(FontAwesomeIcons.envelopeOpen),
            title: Text('Contacto'),
            onTap: () {}),
            Divider(),
        ListTile(
            leading: Icon(FontAwesomeIcons.fileSignature),
            title: Text('Acuerdo de privacidad'),
            onTap: () {}),
            Divider(),
        ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text('Cerrar sesión'),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cerrar sesión'),
                    content: Text('Esta seguro de salir de la aplicación?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancelar')),
                      TextButton(
                        onPressed: () => {
                          _signOut(),
                          Navigator.of(context).pop(),
                        },
                        child: Text('Salir'),
                      ),
                    ],
                  );
                })),
      ],
    ));
  }
}
