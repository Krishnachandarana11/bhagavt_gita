import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/language.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> jsondata;

  @override
  void initState() {
    super.initState();
    jsondata = rootBundle.loadString("assets/Json/data.json");
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bhagavad Gita Chapters',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFFD700),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: Colors.white),
            onSelected: (String language) {
              languageProvider.changeLanguage(language);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'Hindi',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        // Light golden beige
        color: Color(0xFFFFD700),

        child: FutureBuilder(
          future: jsondata,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFD700),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No data available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              List chapters = jsonDecode(snapshot.data!);
              return ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        'Detail',
                        arguments: chapters[index],
                      );
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFFFF8E1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  chapters[index]['image_name'],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageProvider.selectedLanguage ==
                                              'Hindi'
                                          ? chapters[index]['name']
                                          : chapters[index]['name_translation'],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B4513),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Chapter ${chapters[index]['chapter_number']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFFA0522D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFFFD700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
