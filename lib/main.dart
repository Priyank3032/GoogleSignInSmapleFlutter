import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;
  String username = '';
  String userEmail = '';
  String userPhoto = '';
  late bool _isSingOut;
  late bool _isSingIn;

  @override
  void initState() {
    super.initState();
    _isSingOut = false;
    _isSingIn = true;

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        username = _currentUser!.displayName!;
        userEmail = _currentUser!.email;
        userPhoto = _currentUser!.photoUrl!;
      });

      print("current user ${_currentUser!.displayName}");
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoogleSignIn'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(userPhoto), fit: BoxFit.fill),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10),
                          child: Text(
                            username,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5),
                            child: Text(
                              userEmail,
                              style: TextStyle(fontSize: 13),
                            )),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                  child: ElevatedButton(
                    onPressed: _isSingOut
                        ? () {
                            _handleSignOut();
                          }
                        : null,
                    child: Text('Signout'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
                  child: ElevatedButton(
                    onPressed: _isSingIn ?() {
                      _handleSignIn();
                    } : null,
                    child: Text('Google SignIn'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();

      setState(() {
        _isSingOut = true;
        _isSingIn = false;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        _isSingOut = false;
        _isSingIn = true;

        username = '';
        userEmail = '';
        userPhoto = '';
      });
      print( _googleSignIn.toString());
    } catch (error) {
      print(error);
    }
  }
}
