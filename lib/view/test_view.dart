import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_app/view/chat_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  String accessToken = '';

  String? myToken;
  Future<void> getToken() async {
    myToken = await FirebaseMessaging.instance.getToken();
    log(myToken ?? "no token nigga");
  }

  Future<void> getAccessToken() async {
    try {
      final serviceAccountJson = await rootBundle.loadString(
          'assets/e-commerce-app-2af68-firebase-adminsdk-7agmj-ebd1ef7c5a.json');

      final accountCredentials = ServiceAccountCredentials.fromJson(
        jsonDecode(serviceAccountJson),
      );

      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = http.Client();
      try {
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
          accountCredentials,
          scopes,
          client,
        );

        setState(() {
          accessToken = accessCredentials.accessToken.data;
        });

        print('Access Token: $accessToken');
      } catch (e) {
        print('Error obtaining access token: $e');
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error loading service account JSON: $e');
    }
  }

  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log("initial msg");
      if (initialMessage.data['type'] == 'chat') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatView(text: initialMessage.notification?.body);
        }));
      }
    }
  }

  @override
  void initState() {
    getInit();
    getAccessToken();
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if (message.data['type'] == 'chat') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ChatView();
          }));
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                  child: Container(
                color: Colors.grey.shade700,
                width: double.infinity,
                height: 200,
                child: Center(
                    child: Text(
                  message.data.toString(),
                )),
              )),
            );
          },
        );
      }
    });
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: ElevatedButton(
        child: Text('send message'),
        onPressed: () async {
          await sendMessage('hi', 'eslam');
        },
      ),
    );
  }

  Future<void> sendMessage(title, msgBody) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ya29.c.c0ASRK0GZe0rWJG4V4XsMFmFam7aFfctkKCvcwffCn2QhEarNG8D5HLWYb7Pfd4JFU24TcNYMOyO31Sgt3pEoauujQ4CQXGIIlFDsSPPVI3Q-19nExV_Z0gjmEWhpxIc9m5A_fcnUqGtCWDXyVqgvMDAE3585_2yNLm9KhG_tgxNP7dnJxV0TrmuubS3eMxKLJEnsLsTUkB6JLdrSdWOEu94BVH-67aNypC9hH2BrKyNcV1PMvAOKPIDRBY78G12wCi7Z0C0YPNIIdfA7Vl-TbgsVP5Km98MZjIr9upjSBezmGatZyeNy_6wFDhUL1rZb8Ai2HX9OvC-BzDdzAY5iOy9GSnizSs18_E0zdogsE5tkObRfV27kvj7yjN385PFunp2MoVUuxqi6UmSwBSM3y0w1i9O05uj9ptVpfS2k1x1Ysbh-Fg3cdMQnk7-O_em3VwmfvX5sedF5JIVi33qrlsc7WgwslQfbuXyO_zUgIee6tiQU6hXYMBYyXl9drcwn-i50Fdofv5Bi4s9k7oRZVzBywezl_gJ78IV4cSB8ebavVn35pyyoMYwesjqfR7xpvo-Iikpx7hmpi052F87ZB7qpRQjJ-uWdm1Qjecp8bR8gOkV6Mvy2Zhwpu26tu4rrv6ut2dcXXw45qdh4Vz_2MIy6ZcnRIzu24jxbrSB-26dliS9ZXZuwcjOmWoWFFSwBM179b111oSp7ncSFbyBUfb9me3uuaFWc0YmtImvJqYsd4R_oy94s_lnq2kflscxyB3_tOuQ6mV-mIemmnUlnsRQ7dmFjBJJ3uUkojdcZZhz-s_7FI1Op_Jun-32hgVvUxiYJW5vvfo7Zaa4ommoM5t2xUk_hfUjZWxngoZsRcfbafUZ81Zr9SsnnVhnhOWFqhXnm5viouvm0shje8776Xrz_8r1wycVsp-_-xtBIjwwO2jihO7fF8F5Rx_kMlMx0zzp6i7s1IlUsJ49vOWVaJOJ9Qz0r0f3yBhpf_4JJk'
    };
    var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/e-commerce-app-2af68/messages:send');

    var body = {
      "message": {
        "token":
            "eSu9RFNhS_GUNvDwYPkJYd:APA91bFa1_vjn2hpQHQTpJ5a_TNVBnUyWpFHcO_buJJy9IxSZ1TZz9cmNfKS8JNft3FAvmSAG5pEuLvCs1jW2w0pN0zTpPPglXBSVgGwl0fJUYQFAKX-iuh6XtNTsqWQcYeZHWkhT8fs",
        "notification": {
          "title": "Breaking News",
          "body": "New news story available."
        },
        "data": {"story_id": "story_12345", "name": "El zalton", "type": "chat"}
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
}
