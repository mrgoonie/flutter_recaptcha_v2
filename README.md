# flutter_recaptcha_v2

A Flutter plugin for Google ReCaptcha V2.

## Getting Started

This plugin requires `Webview` to use Google ReCaptcha.
This plugin only supports **Google ReCAPTCHA V2** (not V3)

Obtain your own key & secret here: https://www.google.com/recaptcha

**!!! Remember to add this domain into the reCaptcha setting or add your own domain: recaptcha-flutter-plugin.firebaseapp.com**

Then test your API KEY at: https://recaptcha-flutter-plugin.firebaseapp.com/?api_key=API_KEY

Put `RecaptchaV2` widget into your widget tree (Usually inside `Stack` widget), **make sure it's placed on top of the tree and block all the behind interactions**:

- You can change the plugin url for the captcha domain insde the RecaptchaV2 or leave it by default non adding the line:

```dart
pluginURL: "https://mypersonalurl.com"
```

**if you have setted your own domain, specify the domain used**


- To show the Cancel Button with the captcha controller set the boolean to `true`:
```dart
visibleCancelBottom: true
```

 **otherwise it won't appear**

- Set the Text for the Cancel buttom or leave it by default:
```dart
textCancelButtom: "CANCEL CAPTCHA"
```

### Example

```dart
RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
...
RecaptchaV2(
    apiKey: "YOUR_API_KEY", // for enabling the reCaptcha
    apiSecret: "YOUR_API_SECRET", // for verifying the responded token
    pluginURL: "https://mypersonalurl.com",
	visibleCancelBottom: true,
	textCancelButtom: "CUSTOM CANCEL CAPTCHA BUTTOM TEXT",
	controller: recaptchaV2Controller,
    onVerifiedError: (err){
        print(err);
    },
    onVerifiedSuccessfully: (success) {
        setState(() {
            if (success) {
                // You've been verified successfully.
            } else {
                // "Failed to verify.
            }
        });
    },
),
```

The `RecaptchaV2` widget is hidden by default, you need to attach the `RecaptchaV2Controller` and call `show()` method when needed. Like this:
```dart
recaptchaV2Controller.show();
```

Manually hide it:
```dart
recaptchaV2Controller.hide();
```

That's it!

