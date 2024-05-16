import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class JikanApi {
  static const String baseUrl = 'https://api.jikan.moe/v4/anime';

  Future<List<Map<String, dynamic>>> searchAnime(String query) async {
    // Construct the API URL with the query
    String apiUrl = '$baseUrl?q=$query';

    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body)['data'];

        // Convert each JSON object to a map
        List<Map<String, dynamic>> results = [];
        data.forEach((anime) {
          results.add({
            'name': anime['name'],
            'title': anime['title'],
            'url': anime['url'],
            'image_url': anime['images']['jpg']['image_url']
          });
        });

        return results;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load anime');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      throw Exception('Error: $e');
    }
  }

  Future<String?> fetchYouTubeTrailerUrl(String animeName) async {
    var apiKey = 'AIzaSyBvq0MdbbDF7oHCJspESpA02dwph7X6GFE';
    var query = animeName + ' trailer';
    var url = Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        // Assuming the first result is the most relevant one
        var videoId = data['items'][0]['id']['videoId'];
        return 'https://www.youtube.com/watch?v=$videoId';
      }
      return null;  // No results found
    } else {
      throw Exception('Failed to load trailer');
    }
  }


}
