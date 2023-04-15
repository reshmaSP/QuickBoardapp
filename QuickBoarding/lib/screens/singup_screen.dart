import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../aadhar/main.dart';
import 'home_screen.dart';
import '../helpers/firebase_auth.dart';
import '../helpers/validator.dart';
import 'package:email_otp/email_otp.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  bool flag = false;

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 11, 120, 209),
          title: Text('Create Account'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Name",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        // TextFormField(
                        //   controller: _emailTextController,
                        //   focusNode: _focusEmail,
                        //   validator: (value) => Validator.validateEmail(
                        //     email: value,
                        //   ),
                        //   decoration: InputDecoration(
                        //     hintText: "Email",
                        //     errorBorder: UnderlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6.0),
                        //       borderSide: BorderSide(
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 12.0),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: TextFormField(
                                          controller: email,
                                          decoration: const InputDecoration(
                                              hintText: "User Email")),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          myauth.setConfig(
                                              appEmail: "me@quickBoarding.com",
                                              appName: "Email OTP",
                                              userEmail: email.text,
                                              otpLength: 6,
                                              otpType: OTPType.digitsOnly);
                                          if (await myauth.sendOTP() == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP has been sent"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Oops, OTP send failed"),
                                            ));
                                          }
                                        },
                                        child: const Text("Send OTP")),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: TextFormField(
                                          controller: otp,
                                          decoration: const InputDecoration(
                                              hintText: "Enter OTP")),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (await myauth.verifyOTP(
                                                  otp: otp.text) ==
                                              true) {
                                            flag = true;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text("OTP is verified"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text("Invalid OTP"),
                                            ));
                                          }
                                        },
                                        child: const Text("Verify")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        if (_registerFormKey.currentState
                                                .validate() &&
                                            flag) {
                                          User user = await FirebaseAuthHelper
                                              .registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: email.text,
                                            password:
                                                _passwordTextController.text,
                                          );

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                          if (user != null) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) => App(),
                                              ),
                                              ModalRoute.withName('/'),
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepOrangeAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
