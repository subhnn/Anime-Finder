import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {


  Future<dynamic> SearchApi(String name,
      ) async
  {
    var client = http.Client();
    var apiUrl = Uri.parse("https:localhost:3001//api.jikan.moe/v4/anime/{id}/full");

    var response = await client.post(apiUrl,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, String>{
          "name": name,

        })
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      throw Exception("failed to add");
    }
  }

}