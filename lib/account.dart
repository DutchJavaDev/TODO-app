import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils/extension.dart';

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

  bool login = true;
  bool hasEmail = false;
  bool hasPassword = false;
  bool send = false;

  String emailError = "";
  String passwordError = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

    if (password.uppercaseCount() == 0){
      passwordError = "Password must contain atleast 1 uppercase letter";
      return false;
    }

    if (password.lowerCaseCount() == 0){
      passwordError = "Password must contain atleast 1 lowercase letter";
      return false;
    }

    if (!password.containsSpecialCharacter()){
      passwordError = "Password must contain atleast 1 special character";
      return false;
    }

    return true;
  }

  List<Widget> _loginView() {
    var list = new List<Widget>();

    var emailField = CupertinoTextField(
      placeholder: "Enter your e-mail",
      autocorrect: false,
      controller: emailController,
      placeholderStyle:
          TextStyle(fontSize: 18, color: CupertinoColors.inactiveGray),
      keyboardType: TextInputType.emailAddress,
      cursorRadius: Radius.circular(12),
    );

    list.add(Padding(
      padding: EdgeInsets.only(left: 6, right: 6),
      child: Container(
        child: Column(
          children: <Widget>[
            emailField,
            Text(emailError,style: TextStyle(color: CupertinoColors.destructiveRed,fontSize: 16),)
          ],
        ),
        height: 66,
      ),
    ));

    var passwordField = CupertinoTextField(
        placeholder: "Enter your password",
        obscureText: true,
        controller: passwordController,
        placeholderStyle:
            TextStyle(fontSize: 18, color: CupertinoColors.inactiveGray));

    list.add(Padding(
      padding: EdgeInsets.only(left: 6, right: 6, top: 12),
      child: Container(
        child: Column(
          children: <Widget>[
            passwordField,
            Text(passwordError,style: TextStyle(color: CupertinoColors.destructiveRed,fontSize: 16),)
          ],
        ),
        height: 66,
      ),
    ));

    list.add(Padding(
      padding: EdgeInsets.only(top: 12, left: 6, right: 6),
      child: Container(
          height: 68,
          width: double.infinity,
          child: CupertinoButton(
            child: send ? CupertinoActivityIndicator() : Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            onPressed: (hasEmail && hasPassword) ? (){
              setState(() {
                
                send = !send;

              });
            } : null,
            color: CupertinoColors.activeBlue,
            disabledColor: CupertinoColors.inactiveGray,
          )),
    ));

    return list;
  }

  List<Widget> _registerView() {
    var list = new List<Widget>();

    var emailField = CupertinoTextField(
      placeholder: "Enter your e-mail",
      autocorrect: false,
      controller: emailController,
    );

    list.add(Padding(
      padding: EdgeInsets.only(),
      child: emailField,
    ));

    var passwordField = CupertinoTextField(
      placeholder: "Enter your password",
      obscureText: true,
      controller: passwordController,
    );

    list.add(Padding(
      padding: EdgeInsets.only(),
      child: passwordField,
    ));

    list.add(Padding(
      padding: EdgeInsets.only(),
      child: CupertinoButton(
        child: Text("Register"),
        onPressed: () {
          print(
              "Register-> username: ${emailController.text}, password: ${passwordController.text}");
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
            children: login ? _loginView() : _registerView(),
          )),
    );
  }
}
