import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show AssetImage, BoxFit, BuildContext, Center, Colors, Icons, Image, Key, MaterialPageRoute, Scaffold, State, StatefulWidget, Widget;
import 'package:practicum_1/Screens/home_screen.dart';
import 'package:practicum_1/Screens/signup_screen.dart';

import '../reusable_widgets/reuseable_widgets.dart';


class SigninScreen extends StatefulWidget {
   SigninScreen({Key? key}) : super(key: key);


  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Container(
        decoration: const BoxDecoration(
          image:DecorationImage(
              image:AssetImage('assets/green.png' ),
              fit: BoxFit.cover
          )

        )
      ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('EVENTS',style: TextStyle(fontSize: 70,fontWeight: FontWeight.bold,
              color: Colors.white)),
              reusableTextField("Enter UserName", Icons.person_outline , false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 5,
              ),
              signInSignUpButton(context, true, (){
                FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text,
                    password: _passwordTextController.text).then((value){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                }).onError((error, stackTrace){
                  print("Error ${error.toString()}");
                });

              }),
              signInSignUpButton(context, true, (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                }),
              signUpOption()
            ]

      ),
      )
    );

  }
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
