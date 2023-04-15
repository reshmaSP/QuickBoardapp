import 'package:flutter_app/screens/login_screen.dart';

import 'listpage.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:convert';
import 'package:crypto/crypto.dart';
// import 'package:flutter/src/foundation/key.dart'
// import 'package:encrypt/encrypt.dart';

import '../services/firebase_crud.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPage();
  }
}

String myencrypt(String text) {
  final plainText = text;
  final key = enc.Key.fromUtf8('my 32 length key................');
  final iv = enc.IV.fromLength(16);

  final encrypter = enc.Encrypter(enc.AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  return encrypted.base64;
}

class _AddPage extends State<AddPage> {
  final _user_name = TextEditingController();
  final _user_age = TextEditingController();
  final _user_gender = TextEditingController();
  final _user_address = TextEditingController();
  // final _employee_positio = TextEditingController();
  final _user_contact = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        controller: _user_name,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final ageField = TextFormField(
        controller: _user_age,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Age",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final genderField = TextFormField(
        controller: _user_gender,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Gender",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final addressField = TextFormField(
        controller: _user_address,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        //     decoration: InputDecoration(
        //         contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //         hintText: "Name",
        //         border:
        //             OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
        // final positionField = TextFormField(
        //     controller: _employee_position,
        //     autofocus: false,
        //     validator: (value) {
        //       if (value == null || value.trim().isEmpty) {
        //         return 'This field is required';
        //       }
        //     },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Adresss",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final contactField = TextFormField(
        controller: _user_contact,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contact Number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LoginScreen(),
            ),
            (route) => false, //To disable back feature set to false
          );
        },
        child: const Text('Go to Home Screen'));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var response = await FirebaseCrud.addEmployee(
                name: myencrypt(_user_name.text),
                age: myencrypt(_user_age.text),
                gender: myencrypt(_user_gender.text),
                address: myencrypt(_user_address.text),
                contactno: myencrypt(_user_contact.text));
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });

              //  Navigator.of(context).push(
              //     MaterialPageRoute(builder: (_) => LoginScreen()),
              //   );
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Enter Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  const SizedBox(height: 25.0),
                  ageField,
                  const SizedBox(height: 35.0),
                  genderField,
                  const SizedBox(height: 25.0),
                  addressField,
                  const SizedBox(height: 35.0),
                  contactField,
                  const SizedBox(height: 35.0),
                  viewListbutton,
                  const SizedBox(height: 45.0),
                  SaveButon,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
