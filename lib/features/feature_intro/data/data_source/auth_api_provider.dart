import 'dart:convert';
import 'package:alzahra/config/constants.dart';
import 'package:alzahra/features/feature_home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

Future userValidate(
    {required context, required String email, required String password}) async {
  debugPrint(email.toString());
  debugPrint(password.toString());
  final response = await http.post(
      Uri.https(
        Constants.baseUrl,
        '/api/v1/login',
      ),
      body: {
        'email': email,
        'password': password,
      });
  debugPrint(response.statusCode.toString());
  if (response.statusCode == 200) {
    Constants.getStorage.write('userData', {
      'email': email,
      'password': password,
      'photo': jsonDecode(response.body)['photo'],
      'name': jsonDecode(response.body)['name'],
      'study_stages': jsonDecode(response.body)['study_stages'],
      'evidence': jsonDecode(response.body)['evidence'],
      'token': jsonDecode(response.body)['token']
    });

    Navigator.pushReplacement(
      context,
      PageTransition(
        child: const HomePage(),
        type: PageTransitionType.bottomToTop,
      ),
    );
  } else if (response.statusCode == 422) {
    return jsonDecode(response.body);
  } else {
    throw 'Erorr';
  }
}
