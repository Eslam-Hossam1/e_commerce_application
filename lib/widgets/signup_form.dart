import 'dart:developer';

import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/helper/add_space.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_obsecure_text_form_field.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late String username;
  late String email;
  late String password;
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Username",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              addHieghtSpace(8),
              CustomeTextFormField(
                hintText: "Username",
              ),
              addHieghtSpace(12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              addHieghtSpace(8),
              CustomeTextFormField(
                onSaved: (value) {
                  email = value!;
                },
                hintText: "Email",
              ),
              addHieghtSpace(12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              addHieghtSpace(8),
              CustomeObsecureTextFormField(
                onSaved: (value) {
                  password = value!;
                },
                hintText: "Password",
              ),
              addHieghtSpace(32),
              CustomeElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      log("pls go verify your email nigga");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginView();
                      }));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        log('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        log('The account already exists for that email.');
                      }
                    } catch (e) {
                      log(e.toString());
                    }
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                text: "Sign Up",
              )
            ],
          ),
        ));
  }
}
