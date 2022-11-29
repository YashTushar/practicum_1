import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reuseable_widgets.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  Widget build(BuildContext context) {
    return  Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body:Container(
          decoration: const BoxDecoration(
              image:DecorationImage(
                  image:AssetImage('assets/events.jpeg' ),
                  fit: BoxFit.cover
              )

          )
          ,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                reusableTextField("Enter UserName", Icons.person_outline , false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email-Id", Icons.person_outline , false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
               signInSignUpButton(context, false , (){
                 FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text,
                     password: _passwordTextController.text ).then((value){
                       print("Created New Account");
                 Navigator.push(context,
                 MaterialPageRoute(builder: (context)=>const HomeScreen()));
                 }).onError((error, stackTrace){
                   print("Error ${error.toString()}");
                 });
               }),
                signInSignUpButton(context, false , (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const HomeScreen()));
                  })
              ]

          ),
        )
    );

  }
}

