import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'jikanapi.dart';
import 'package:animate_do/animate_do.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final JikanApi jikanApi = JikanApi();

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title:const Text(
        'AnimeFinder',

        style: TextStyle(
        color: Color.fromRGBO(19, 61, 95, 1), // Set your desired color here
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
    ),
      ),

      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 80),
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              controller: _searchController,
              decoration: InputDecoration(


                labelText:'Search for Anime',

                hintText: 'Enter Anime Name',


                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(20).copyWith(topLeft: Radius.zero)
                ),

              ),
            ),

            SizedBox(height: 16.0),
            ElevatedButton(

              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
              onPressed: () {
                String query = _searchController.text;
                _searchAnime(query);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Container(); // Return an empty container if there are no search results
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final anime = _searchResults[index];

            // String animeName = anime['name'] ?? "not";
            String animeTitle = anime['title'] ?? 'No title available';
            String animeUrl = anime['url'] ?? "Not found";
            String animeImage = anime['image_url'] ?? "Not found";

            return SingleChildScrollView(


              child: Container( color:Colors.white12,


                child: ListTile(

                  leading: Container(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      animeImage,
                      height: 300,
                    ),
                  ),
                  title: Text(animeTitle),
                  subtitle: InkWell(
                    onTap: () {
                      _launchURL(animeUrl);
                    },
                    child: Text(
                      'URL: $animeUrl',
                      style: TextStyle(
                        color: Colors.blue,
                        // Make the text blue to indicate it is clickable
                        decoration: TextDecoration
                            .underline, // Underline to indicate it's a link
                      ),
                    ),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,

                    // To limit the size of the column to the size of its children
                    children: [

                      Flexible(

                        child: IconButton(
                          iconSize: 20,
                          icon:
                              Icon(Icons.play_circle_fill, color: Colors.black),
                          onPressed: () async {
                            // Fetch and launch YouTube trailer URL
                            String? youtubeUrl = await jikanApi
                                .fetchYouTubeTrailerUrl(animeTitle);
                            if (youtubeUrl != null) {
                              _launchURL(youtubeUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'No trailer available for this anime.')));
                            }
                          },
                        ),
                      ),
                      Flexible(
                          child: Text('Watch',
                              style: TextStyle(
                                  fontSize:
                                      12)) // Add Text widget below the IconButton
                          )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _searchAnime(String query) async {
    try {
      List<Map<String, dynamic>> results = await jikanApi.searchAnime(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching anime: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error searching anime: $e')));
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Homepage(),
//   ));
// }
