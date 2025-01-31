import 'dart:developer';

import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/messaging_permission_handler.dart';
import 'package:e_commerce_app/themes/my_theme.dart';
import 'package:e_commerce_app/view/filter_view.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/image_picker_view.dart';
import 'package:e_commerce_app/view/login_view.dart';
import 'package:e_commerce_app/view/signup_view.dart';
import 'package:e_commerce_app/view/test_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  log("Handling a background message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await myRequestPermission();
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatefulWidget {
  const ECommerceApp({super.key});

  @override
  State<ECommerceApp> createState() => _ECommerceAppState();
}

class _ECommerceAppState extends State<ECommerceApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.customeTheme,
      debugShowCheckedModeBanner: false,
      // home: (FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified)
      //     ? const TestView()
      //     : const LoginView(),
      home: const TestView(),
    );
  }
}
