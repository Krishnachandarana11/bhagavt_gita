import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/language.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    String currentLanguage = languageProvider.selectedLanguage;

    Map chapter = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          '${chapter['name']}',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFD700),
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.yellow,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getChapterSummary(chapter, currentLanguage),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: chapter['verses'].length,
                  itemBuilder: (context, i) {
                    Map verse = chapter['verses'][i];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      color: Color(0xFFFFF8E1),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          'Sloka ${verse['Sloka'].toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513), // Brown
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verse['Verse'],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _getVerseContent(verse, currentLanguage),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showVerseBottomSheet(
                            context,
                            verse['Sloka'].toString(),
                            verse,
                            currentLanguage,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getChapterSummary(Map chapter, String language) {
    switch (language) {
      case 'Hindi':
        return chapter['chapter_summary_hindi'] ?? '';
      case 'English':
      default:
        return chapter['chapter_summary'] ?? '';
    }
  }

  String _getVerseContent(Map verse, String language) {
    switch (language) {
      case 'Hindi':
        return verse['Translation_Hindi'] ?? '';
      case 'English':
      default:
        return verse['Translation_English'] ?? '';
    }
  }

  void showVerseBottomSheet(
    BuildContext context,
    String slokaNumber,
    Map verse,
    String currentLanguage,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFFFD700),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Sloka $slokaNumber",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                verse['Verse'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8B4513),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Translation (Hindi):",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 10),
              Text(
                verse['Translation_Hindi'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B4513), // Brown
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              Text(
                "Translation (English):",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 10),
              Text(
                verse['Translation_English'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B4513),
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B4513), // Brown
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
