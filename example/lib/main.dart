import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Google ReCaptcha Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String verifyResult = "";

  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text("SHOW ReCAPTCHA"),
                  onPressed: () {
                    recaptchaV2Controller.show();
                  },
                ),
                Text(verifyResult),
              ],
            ),
          ),
          RecaptchaV2(
            apiKey: "6LfXp1UpAAAAAEku9BSeBt6JJxXrlvtYjh--X4D7",
            apiSecret: "6LfXp1UpAAAAAIFVynIPkooVWZi5qN8u16SYJTVt",
            controller: recaptchaV2Controller,
            onVerifiedError: (err) {
              print(err);
            },
            onVerifiedSuccessfully: (success) {
              setState(() {
                if (success) {
                  verifyResult = "You've been verified successfully.";
                } else {
                  verifyResult = "Failed to verify.";
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
