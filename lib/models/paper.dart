import 'package:xml/xml.dart';

class Paper {
  final String title;
  final List<String> authors;
  final String summary;
  final String pdfUrl;

  Paper({
    required this.title,
    required this.authors,
    required this.summary,
    required this.pdfUrl,
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
    // arXiv Atom feed uses <link title="pdf" href="..." rel="related" type="application/pdf"/>
    // or just <link href="..." rel="alternate" type="application/pdf"/>
    String pdfUrl = '';
    final links = element.findElements('link');
    for (var link in links) {
      if (link.getAttribute('title') == 'pdf' ||
          link.getAttribute('type') == 'application/pdf') {
        pdfUrl = link.getAttribute('href') ?? '';
        break;
      }
    }

    return Paper(
      title: title,
      authors: authors,
      summary: summary,
      pdfUrl: pdfUrl,
    );
  }

  @override
  String toString() {
    return 'Paper(title: $title, authors: $authors)';
  }
}
