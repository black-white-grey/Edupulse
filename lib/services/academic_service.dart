import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/paper.dart';

class AcademicService {
  final http.Client _client = http.Client();

  Future<List<Paper>> searchPapers(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url =
        'https://export.arxiv.org/api/query?search_query=all:$encodedQuery&max_results=15';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final entries = document.findAllElements('entry');

        return entries.map((entry) => Paper.fromXmlElement(entry)).toList();
      } else {
        throw Exception('Failed to load papers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching papers: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
