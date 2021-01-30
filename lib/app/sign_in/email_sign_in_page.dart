import 'package:flutter/material.dart';
import 'package:frolicsports/app/sign_in/email_sign_in_form.dart';
import 'package:frolicsports/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(0), topEnd: Radius.circular(120.0),
                  bottomStart: Radius.circular(150.0),bottomEnd: Radius.circular(0)),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
