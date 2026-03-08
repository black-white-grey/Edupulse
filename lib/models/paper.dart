import 'package:xml/xml.dart';

class Paper {
  final String title;
  final List<String> authors;
  final String summary;
  final String pdfUrl;
  final String publishedYear;
  final String primaryCategory;

  Paper({
    required this.title,
    required this.authors,
    required this.summary,
    required this.pdfUrl,
    required this.publishedYear,
    required this.primaryCategory,
  });

  factory Paper.fromXmlElement(XmlElement element) {
    // Extract title
    final title = element
        .findElements('title')
        .first
        .innerText
        .trim()
        .replaceAll('\n', ' ');

    // Extract authors
    final authors = element.findElements('author').map((authorElement) {
      return authorElement.findElements('name').first.innerText.trim();
    }).toList();

    // Extract summary
    final summary = element
        .findElements('summary')
        .first
        .innerText
        .trim()
        .replaceAll('\n', ' ');

    // Extract PDF link
    String pdfUrl = '';
    final links = element.findElements('link');
    for (var link in links) {
      if (link.getAttribute('title') == 'pdf' ||
          link.getAttribute('type') == 'application/pdf') {
        pdfUrl = link.getAttribute('href') ?? '';
        break;
      }
    }

    // Extract published year
    String publishedYear = 'Unknown';
    final publishedElement = element.findElements('published');
    if (publishedElement.isNotEmpty) {
      final dateStr = publishedElement.first.innerText;
      if (dateStr.length >= 4) {
        publishedYear = dateStr.substring(0, 4);
      }
    }

    // Extract primary category
    String primaryCategory = 'Unknown';
    final categoryElement = element.findElements('arxiv:primary_category');
    if (categoryElement.isNotEmpty) {
      primaryCategory = categoryElement.first.getAttribute('term') ?? 'Unknown';
    } else {
      final altCategory = element.findElements('category');
      if (altCategory.isNotEmpty) {
        primaryCategory = altCategory.first.getAttribute('term') ?? 'Unknown';
      }
    }

    return Paper(
      title: title,
      authors: authors,
      summary: summary,
      pdfUrl: pdfUrl,
      publishedYear: publishedYear,
      primaryCategory: primaryCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors.join('|'),
      'summary': summary,
      'pdfUrl': pdfUrl,
      'publishedYear': publishedYear,
      'primaryCategory': primaryCategory,
    };
  }

  factory Paper.fromMap(Map<String, dynamic> map) {
    return Paper(
      title: map['title'] as String,
      authors: (map['authors'] as String).split('|'),
      summary: map['summary'] as String,
      pdfUrl: map['pdfUrl'] as String,
      publishedYear: map['publishedYear'] as String,
      primaryCategory: map['primaryCategory'] as String? ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'Paper(title: $title, authors: $authors, category: $primaryCategory)';
  }
}
