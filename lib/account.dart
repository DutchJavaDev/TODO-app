import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'utils/extension.dart';
import 'api/api.dart';

class AccountPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccountPanelStateFul();
  }
}

class AccountPanelStateFul extends StatefulWidget {
  @override
  AccountPanelState createState() => AccountPanelState();
}

class AccountPanelState extends State<AccountPanelStateFul> {

  bool login = false;
  bool register = false;
  bool hasEmail = false;
  bool hasPassword = false;

  String emailError = "";
  String passwordError = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final IdentityService _identityService = GetIt.instance.get<IdentityService>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    setState(() {
      emailError = "";
    });

    if (emailController.text.isNullOrEmpty()) {
      setState(() {
        hasEmail = false;
        emailError = "Email must not be empty";
      });
      return;
    }

    if (!emailController.text.validEmail()) {
      setState(() {
        hasEmail = false;
        emailError = "This is not a valid email";
      });
    } else {
      setState(() {
        hasEmail = true;
      });
    }
  }

  void _validatePassword() {
    setState(() {
      passwordError = "";
    });

    if (passwordController.text.isNullOrEmpty()) {
      setState(() {
        hasPassword = false;
        passwordError = "Password must not be empty";
      });
    } else if (_securePassword()) {
      setState(() {
        hasPassword = true;
      });
    } else {
      setState(() {
        hasPassword = false;
      });
    }
  }

  bool _securePassword() {
    var password = passwordController.text;

    if (password.length < 8) {
      passwordError = "Password must be atleast 8 characters long";
      return false;
    }

    if (password.uppercaseCount() == 0) {
      passwordError = "Password must contain atleast 1 uppercase letter";
      return false;
    }

    if (password.lowerCaseCount() == 0) {
      passwordError = "Password must contain atleast 1 lowercase letter";
      return false;
    }

    if (!password.containsSpecialCharacter()) {
      passwordError = "Password must contain atleast 1 special character";
      return false;
    }

    return true;
  }

  void _handleLogin() {}

  void _handleRegister() async {
    var result = await _identityService.registerAccount(
        emailController.text, passwordController.text);
    print(result.toString());
    setState(() {
      register = false;
    });
  }

  List<Widget> _accountView() {
    var list = new List<Widget>();

    list.add(Padding(
      padding: EdgeInsets.only(bottom: 25, left: 6, right: 6),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
            border: Border.all(
                color: CupertinoColors.white,
                style: BorderStyle.solid,
                width: 2)),
        child: Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.info,
                color: Colors.greenAccent,
              ),
              Text(
                "Create a accout to keep your tasks safe for free in our database. We wont look into or share your information or tasks!",
                style: TextStyle(fontSize: 18, color: CupertinoColors.white),
              )
            ],
          ),
        ),
      ),
    ));

    var emailField = CupertinoTextField(
      placeholder: "Enter your e-mail",
      autocorrect: false,
      controller: emailController,
      placeholderStyle:
          TextStyle(fontSize: 18, color: CupertinoColors.inactiveGray),
      keyboardType: TextInputType.emailAddress,
      cursorRadius: Radius.circular(12),
      suffix: Icon(FontAwesomeIcons.at),
      style: TextStyle(fontSize: 20),
    );

    list.add(Padding(
      padding: EdgeInsets.only(left: 6, right: 6),
      child: Container(
        child: emailField,
        height: 48,
      ),
    ));

    list.add(Text(
      emailError,
      style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 20),
    ));

    var passwordField = CupertinoTextField(
      placeholder: "Enter your password",
      obscureText: true,
      controller: passwordController,
      placeholderStyle:
          TextStyle(fontSize: 18, color: CupertinoColors.inactiveGray),
      cursorRadius: Radius.circular(12),
      suffix: Icon(FontAwesomeIcons.lock),
      style: TextStyle(fontSize: 20),
    );

    list.add(Padding(
      padding: EdgeInsets.only(left: 6, right: 6, top: 12),
      child: Container(
        child: passwordField,
        height: 48,
      ),
    ));

    list.add(Text(
      passwordError,
      style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 20),
    ));

    list.add(Padding(
      padding: EdgeInsets.only(top: 16, left: 6, right: 6),
      child: Container(
          height: 68,
          width: double.infinity,
          child: CupertinoButton(
            child: login
                ? CircularProgressIndicator(
                    backgroundColor: CupertinoColors.activeGreen,
                  )
                : Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
            onPressed: (hasEmail && hasPassword)
                ? () {
                    if (login) return;
                    _handleLogin();
                  }
                : null,
            color: CupertinoColors.activeBlue,
            disabledColor: CupertinoColors.inactiveGray,
          )),
    ));

    list.add(Padding(
        padding: EdgeInsets.only(top: 12, left: 6, right: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Or",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 25),
              isComplex: false,
              painter: UnderScorePainter(4),
              willChange: false,
            )
          ],
        )));

    list.add(Padding(
      padding: EdgeInsets.only(top: 0, left: 6, right: 6),
      child: Container(
          height: 68,
          width: double.infinity,
          child: CupertinoButton(
            child: register
                ? CircularProgressIndicator(
                    backgroundColor: CupertinoColors.activeGreen,
                  )
                : Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
            onPressed: (hasEmail && hasPassword)
                ? () {
                    if (register) return;
                    setState(() {
                      register = true;
                    });
                    _handleRegister();
                  }
                : null,
            color: CupertinoColors.systemGreen,
            disabledColor: CupertinoColors.inactiveGray,
          )),
    ));

    list.add(Padding(
      padding: EdgeInsets.only(top: 25),
      child: CupertinoButton(
        child: Text(
          "Skip for now",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ));

    return list;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CupertinoPageScaffold(
          resizeToAvoidBottomInset: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _accountView(),
          )),
    );
  }
}

class UnderScorePainter extends CustomPainter {
  final int thickNess;

  UnderScorePainter(this.thickNess);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < this.thickNess; i++) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()),
          Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
