import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// هذه الدالة لإدارة الردود من السيرفر
void httpResponseHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;

    case 400:
    case 401:
    case 403:
      showSnackBar(
        context,
        jsonDecode(response.body)['msg'] ?? 'حدث خطأ في الطلب.',
      );
      break;

    case 500:
    default:
      showSnackBar(context, 'حدث خطأ في السيرفر. حاول لاحقاً.');
      break;
  }
}

/// لعرض رسالة بشكل Snackbar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
