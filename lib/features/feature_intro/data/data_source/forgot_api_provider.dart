import 'dart:convert';
import 'package:alzahra/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future userForgotPassword({required String email}) async {
  final response = await http.post(
    Uri.https(Constants.baseUrl, '/api/v1/forget-password', {'email': email}),
  );
  debugPrint(response.statusCode.toString());
  debugPrint(jsonDecode(response.body).toString());
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {
      'errors': ['بريد المستخدم غير مسجل']
    };
  }
}
