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
                  message.notification!.body!,
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
          'Bearer ya29.c.c0ASRK0GY0vSU13NTYnlOODPSNlu3yuJFq7zmocFADMqqyTC1UhjrbaR9Sg4KZSf1pmuEOjaRmcSzewuve4gUyRwGYxYYBHry_weKqsSXCjPti4a8-SGypSmaJOKlntTsmyHZocH-PsB-dZds6RFNzoDCREQis0LqGRt1ZQhDflH-ZXdSHZ8jVrbTkFIdchvacEq7fwvvi9yduNpyB2QyXzQ1S1V8Mc2leJmEgPelaFCc4Er-M_vlNr5ctAEZnGbxJD96tJTtfJaR7y78Tjkyl3JK20scb4-ihnZ5ivqYJTfJHHT-vk_-v-MtyvmJTiw0IBPz4PYNInyynWUSAH9tx4MBupWcMlBrxSWb-9uEdI7tBcnoyPE0tbHSUE385Cufc7O7W52VkqzW_nmQ7ouleaf9eSZ0MkB9p5i2ucb56ik8rxQeJtItaxciv1dqgw3XkgO3R2uaj4j6h_JykiO2aigM7x6QWffiRRFMZ35er46xXeud6eYkbzOrR6ztIrtZ39cmIy6rZXwU7t43ZnltjvFYseI_zqMFUBnZcS7-RaySR9aY6JhaXWwjr67mcRiqXF0I06uaSOo-eu100vq5blgtgc12l4xwBtopiUzhvtFrQnyfaWokkxW6sRlos3oO_JXJMchbju74Jg8zlYocZ_wcornQndtSygQrYjOaF6c7xmn_srm7BgMqt08xgUOWhmMaZXuFd3p698_9oSpiWBad4xM0n1Skyoa3-Sd95kyxQezOSaWjqOS1Q9pze3osj3gWfd9Qub-IXnz4505r8xdR2dImlVcmBJVlcV2R8nQYncQOXciQBnIWeuQcxkh4tp-6Zk7nhMSf10w2xvM0OB_FF_ptgmfyB2uieyI0F_jmJM4qVIg8uxcSXRcgkac_z_SnMqIzO0J8mZQQ47-pgi-3iqYka5gQzOipmR_tV8skyhujfjXns9BqUcmj4Vb8YyUmwzROhj41z2wYF42F1Fiisok5kIBel7sYuvi4m'
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
        "data": {"story_id": "story_12345"}
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
