import 'dart:convert';
import 'dart:developer';

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
  String? myToken;
  Future<void> getToken() async {
    myToken = await FirebaseMessaging.instance.getToken();
    log(myToken ?? "no token nigga");
  }

  @override
  void initState() {
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
          'Bearer ya29.c.c0ASRK0GZgGMYRGwhhNyRNzOMbubs4qJ_Afj4hyguHDupnguUgzC7OnQnBrPd0rJOAw0IK3dw74GxGN4PGWmP6CeSRyrsOAij4prk5SPJK21iaZw6JlhBdOiPA9va_CtAZvR7gbiIORHQW6vs_-0JGXEUihWhDMP4HBmYKMXAlHQ-I6PY1FGupP6pr9sMeATPtRxWCa1Y2ld95o5aP1UmnL3mF5n5YsoITRyCfzeCMTAIA2lfbQXxcX0Cx4217eUwGRRVuhSQ-iU9tUU8qSDJrhgWbSm49mjrlcVPa3qdME3k4lIgqRB6DU1D1AV2nl8O-inU9-RMDJCCWtD-HrJ2bEsk_tlK-4TwpgCbhj_bOsuJqkjwv0tQyw4K_cAL387C-V-vekam51cfho5767-bJhvYWib1rvc5Ukel4hMfs0imiqt07e3Iim0dipRnlzbSZ3SJm0niiisB48lbcBl41VngeffRRfq_oiytckFYhRYX6w0_Zijraqqz0QB81iwthQaFqf-O_9aa2R9bQvcju5t9WFzxpV4cqhsqw9pF4JkUchgesmSYM6fastepMSm8n7VmVVdu_yY4kJl3Jx81kmBBvaYxpBpJamts6un7Vs7xQVMmSfht_zoOxwB--IimjJ7h_wV7tXWMUJ1d9dcjxO9p3gr5yOwXfytW3py9Z-FZVdm5jyB9dxleS4-MMcForp39kS9zR2wQ309JbaZ5FlIYcRB6-mVSq7WsskcBbR3m3q9ybeogn_XgcYpangYlXfVoiMl8SJhsQIueBF02_x8UX751VR898fzSJuwi0_hesMQhg0zoJ7BXFv-vZqX94ewwrm3t4dZaU8nf7B5aYywjdYU-igMb7huYXFBccZf1yYvyghVdY7wquJvXwavx14_k8SmuYzc6Vg3XRnO_h7_oOapI1ejuv1kvnxeumlp5lMecfvaYS9tuZFU8FjRsyBrads_zVYpmpFb1r8dyt3v-u9X61xaa62p4f784r'
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
        "data": {"story_id": "story_12345", "name": "El zalton"}
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
