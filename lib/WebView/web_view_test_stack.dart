// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:provider/provider.dart';
import '../Common/change_notifiers.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as Path;

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  String lastRequestUrl = "";
  int lastRequestAttempt = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (HttpResponseError error) {print("onHttpError: $error");},
          onWebResourceError: (WebResourceError error) {print("onWebResourceError$error");},
          onPageStarted: (url) {
            //print("onPageStarted"+url);
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            //print("onProgress"+progress.toString());
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            //print("onPageFinished"+url);
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) async {
            /*print("onNavigationRequest: "+navigation.isMainFrame.toString());
            if (lastRequestUrl != navigation.url) {
              lastRequestUrl = navigation.url;
              lastRequestAttempt = 1;
            } else if (lastRequestAttempt == 3) {
              lastRequestAttempt = 0;
              // open file in browser or download file
              //_launchInBrowser(Uri.parse(navigation.url));
*/
            if(navigation.url.toUpperCase().contains('DOWNLOAD')) {
              _launchInBrowser(Uri.parse(navigation.url));
              /*if (await Permission.storage.isPermanentlyDenied) {
                // The user opted to never again see the permission request dialog for this
                // app. The only way to change the permission's status now is to let the
                // user manually enables it in the system settings.
                openAppSettings();
              }


              if (await Permission.storage.request().isGranted) {
                final cookieManager2 = WebviewCookieManager();
                final gotCookies = await cookieManager2.getCookies(Uri.parse(navigation.url).host);
                String cookies = gotCookies.toString();
                cookies = cookies.substring(1, cookies.length - 1);


                String path = "${await getDownloadPath()}";
                path = Path.join(path, "MendelUpp_${Path.basename(navigation.url)}");


                final dio = Dio();
                final response = await dio.download(
                  navigation.url, path,
                  options: Options(
                    headers: {'cookie': cookies},
                    method: 'GET',
                  ),
                );


                OpenFile.open(path);
              } else {
                _launchInBrowser(Uri.parse(navigation.url));
              }*/


              return NavigationDecision.prevent;
            }
           /* } else {
              lastRequestAttempt++;
            }*/
            //

            final host = Uri.parse(navigation.url).host;
            print("onNavigationRequest: "+navigation.url);
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Pepa',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OffStageNotify>(
      builder: (context, notifier, child) { //print("OffStage: "+notifier.value.toString());
        return Offstage(
          offstage: notifier.value,
          child: Stack(
            children: [
              WebViewWidget(controller: widget.controller),
              if (loadingPercentage < 100) LinearProgressIndicator(value: loadingPercentage / 100.0)
            ],
          )
        );
      }
    );
  }
}
