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
      body: Column(
        children: [
          ElevatedButton(
            child: Text('subscribe sokkary'),
            onPressed: () async {
              await FirebaseMessaging.instance.subscribeToTopic('sokkary');
            },
          ),
          ElevatedButton(
            child: Text('unsubscripe  sokkary'),
            onPressed: () async {
              await FirebaseMessaging.instance.unsubscribeFromTopic("sokkary");
            },
          ),
          ElevatedButton(
            child: Text('send message'),
            onPressed: () async {
              await sendMessage('hi', 'eslam');
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(title, msgBody) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ya29.c.c0ASRK0GZcsXb2zerA0MJHjacpF6l4fLRRK6Z-sgfJVT9ZXTNEB3DKaV_B_wS915GMH028INUFiTYAg2NjD_pQl5okvGDj8WClnHgVXFQ6uk3YIcTQ_IyLZhYHVtBdG18hLGhrqvj_3BXdHEcIO6HvlLQ0371URWx575kpqmV7MsAoCdDZ7Y5BTfUJzTtWHjh7oP_8Nmo__OfH6Tkul94YOk7jvvQ6ZNcvFBlcJtLIh298du-SBi5MJglAYifgHal3yisyYij4LX2RDr5jV4cV5J-GKrADwqKOeweLdPVYNC7JxZQAXgaRfVkJRD-9cyXDH_YJoToJXFyxXiYj8vtjXVx-KgOdE5wzX2w32nPkXsD6-LUsXIoqzK5JFAN387KUBkwwz-rkw_ekOuhd5iZ5jJnwYhok-V-ZxZMOuevUrSUgg4alYdkkjbV6v8sfQwYz53j31oe2IwMlxq5f0WI42eOxjQQzVB5opsqI2SBSrZeVo0lZaOpmSglbmg_QScgoVdQcweduM-fsfkXlQYjwWRvjX2FkySk4_YvhbrxIQy8b7n5Mg39dm2u_Iclj-qMyh-zzy9MYWXMn-m3tuSgtoQ3_sn8u8Js9FXBhJr_nvX387JQ4spavq6pJcVj_jIMSkQU1RQv_IjSvdVxokni9OkFW9zjx20UvYZOBrb2pZqBgz_9F2gp_Z3O3qYlVQkwyZROizftrFYi498c3nuO1BSzy8J9usMec9pq4keqVBbdXWj3mQnoo8-JXpcy7_qdwM4ptk3cwXztQQnW4Ww8V3zY48S1Qes4-Fn8MhjZwQ4zMwqzYeduzgcMtX-_791Sl_tld6nUJauF3t9JIJaJuiou2cmd5_a-50eqlel2JbVFMtl0VZX8zOm4pOb-Yr2Xle_277eOq3iIB8bV67nshI6jY61iBa4_cy-uBJuy54I9th8hpdbwir3aeFQxpfd71BlY-2O4bZ8m4UBwpfnQykcwud4MkRl8rt03X4Xxe'
    };
    var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/e-commerce-app-2af68/messages:send');

    var body = {
      "message": {
        "topic": "sokkary",
        "notification": {
          "title": "Breaking News",
          "body": "New news story available."
        },
        "data": {"story_id": "story_12345", "name": "sokkary", "type": "chat"}
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
