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

  @override
  void initState() {
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
          'Bearer ya29.c.c0ASRK0GbRhn6BrXnw273PDv88n4m_R6-DQB8v1gpTMMNb57BSdffARwuXL1CzOWhU54-SL6dxBqV11UJdJ0yQgeqK1BafOmJCE7M7djJuEFkRxrts1XHAJTBJjlzPVve_onj7uem1rZFrLoITpA-kVM_2TpQEhbUWO9ixNglisnf0AqyDM3_4b8iteSpInjw_utiq78grE-Zlwx_0AtS0UpN3aJdjYbQ-N8DSjGjqILaMo50yx0TFMhPS3PYd7z0ZIdclA6CrXe_9zsX99G9JCVMcCgO_uViGqUiUkhbH9uy9NVvsb43xEIshVt7BlcYeWo1y3-R4gsUKwQLu0Z6BDIShSnn-cCoABmaQwpneJmcKHq0_hJSeV3LGN385Atn3IWZu6gOUksWc23xe2lY1W4dr4wk1by8rZ9FnSvj_a-6kbsXBjscxt7pp184I7udtuVxX06ShSY0d_0tgn59cJu_uMvj4B9ib-aiIW4hve_1cJZFyn_Xp8OM0jflVWwfsUUUsqmkBpi2o6yZBjyvSuQRReqxcIktusvvob8uQmw8SpuiUpi050S2gOmpVR0Q84XwVV1vFO7l_9F71yoX_iXtF_fbFlW8Vcq-fOWenp3RJoMRJZnBnq03B4OfMS0vFjR_R9w50w810ds_wQez5Y3t_c-nZqkXhopaopF8M3yuuQOwFwtMxujU2XUulh0BYaaUrwM4c7a41tWd5ZFdq7aptsyw602g3O45ZMQUwYWbrzU_9uhY-e6d40djIx5Me6kIt0YaIxvbrm1Ss3dud7tosOsSaxh-p6kkJIy6YI_7qoipJ1XcB990J-eYz2Uccl8nFVbv6Yt4_1lxsFMMJWpmihMOluWhmtwfoy-lSB0XS4B3k_q-3nY5WtUOis-1XyjeeSlU5hQhZngc5dMXrwh0cUWlMqUxF5516Sk3cUwq--QBaJs-_0jlcmztozg7BOjjU0XmOIZqefJF5MIuzcInqJ4rim1mB7h0JVhF6'
    };
    var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/e-commerce-app-2af68/messages:send');

    var body = {
      "message": {
        "token":
            "cpCDIc7vQOOl9xYPGWpTn0:APA91bG-gxKGfgHLiCXMP9JybAq_tXWqs4JYknxlQCsbK-DnEb-cSl1fuFzJF_w9W6iCQuHJ7l615AaxzhWg-aGKc_M1ZlzJdVZUQncI-SOk6xHpXknHEYo8pI9QJoMSO6CZFDYIPe6s",
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
