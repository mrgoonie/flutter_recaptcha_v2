library flutter_recaptcha_v2;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class RecaptchaV2 extends StatefulWidget {
  final String apiKey;
  final String? apiSecret;
  final String pluginURL;
  final RecaptchaV2Controller controller;
  final bool autoVerify;
  bool visibleCancelBottom;
  String textCancelButtom;

  final ValueChanged<bool>? onVerifiedSuccessfully;
  final ValueChanged<String>? onVerifiedError;
  final ValueChanged<String>? onManualVerification;

  RecaptchaV2({
    required this.apiKey,
    this.apiSecret,
    this.pluginURL = "https://recaptcha-flutter-plugin.firebaseapp.com/",
    this.visibleCancelBottom = false,
    this.textCancelButtom = "CANCEL CAPTCHA",
    RecaptchaV2Controller? controller,
    this.onVerifiedSuccessfully,
    this.onVerifiedError,
    this.onManualVerification,
    this.autoVerify = true,
  })  : controller = controller ?? RecaptchaV2Controller(),
        assert(apiKey != null, "Google ReCaptcha API KEY is missing.");

  @override
  State<StatefulWidget> createState() => _RecaptchaV2State();
}

class _RecaptchaV2State extends State<RecaptchaV2> {
  late RecaptchaV2Controller controller;
  late final WebViewController _controller;

  void verifyToken(String token) async {
    String url = "https://www.google.com/recaptcha/api/siteverify";
    http.Response response = await http.post(Uri.parse(url), body: {
      "secret": widget.apiSecret,
      "response": token,
    });

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      if (json['success']) {
        widget.onVerifiedSuccessfully!(true);
      } else {
        widget.onVerifiedSuccessfully!(false);
        widget.onVerifiedError!(json['error-codes'].toString());
      }
    }
    controller.hide();
  }

  void onListen() {
    setState(() {
      controller.visible;
    });
  }

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController webControll =
        WebViewController.fromPlatformCreationParams(params);

    webControll
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'RecaptchaFlutterChannel',
        onMessageReceived: (JavaScriptMessage receiver) {
          String _token = receiver.message;
          if (_token.contains("verify")) {
            _token = _token.substring(7);
          }
          if (widget.autoVerify) verifyToken(_token);
          widget.onManualVerification!(_token);
        },
      )
      ..loadRequest(Uri.parse("${widget.pluginURL}?api_key=${widget.apiKey}"));

    _controller = webControll;

    controller = widget.controller;
    controller.addListener(onListen);
    super.initState();
  }

  @override
  void didUpdateWidget(RecaptchaV2 oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(onListen);
      controller = widget.controller;
      controller.removeListener(onListen);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.removeListener(onListen);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.visible
        ? Stack(
            children: <Widget>[
              WebViewWidget(controller: _controller),
              Visibility(
                visible: widget.visibleCancelBottom,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            child: Text(widget.textCancelButtom),
                            onTap: () {
                              controller.hide();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}

class RecaptchaV2Controller extends ChangeNotifier {
  bool isDisposed = false;
  List<VoidCallback> _listeners = [];

  bool _visible = false;
  bool get visible => _visible;

  void show() {
    _visible = true;
    if (!isDisposed) notifyListeners();
  }

  void hide() {
    _visible = false;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _listeners = [];
    isDisposed = true;
    super.dispose();
  }

  @override
  void addListener(listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(listener) {
    _listeners.remove(listener);
    super.removeListener(listener);
  }
}
