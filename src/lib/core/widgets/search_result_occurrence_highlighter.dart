import 'package:flutter/material.dart';

class SearchResultOccurrenceHighlighter extends StatelessWidget {
  final String source;
  final String? query;
  final TextStyle normalStyle;
  final TextStyle highlightStyle;
  const SearchResultOccurrenceHighlighter({
    super.key,
    required this.source,
    this.query,
    required this.normalStyle,
    required this.highlightStyle,
  });

  /// This function is used to highlight part of the search result
  ///  name that matches the search query
  List<TextSpan> _highlightOccurrences(final String? query) {
    if (query == null || query.isEmpty) {
      return [
        TextSpan(text: source, style: normalStyle),
      ];
    }

    final matches = <TextSpan>[];
    final lowerSource = source.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    while (true) {
      final index = lowerSource.indexOf(lowerQuery, start);
      if (index < 0) {
        // no more matches
        matches
            .add(TextSpan(text: source.substring(start), style: normalStyle));
        break;
      }

      if (index > start) {
        matches.add(
          TextSpan(
            text: source.substring(start, index),
            style: normalStyle,
          ),
        );
      }

      matches.add(
        TextSpan(
          text: source.substring(index, index + query.length),
          style: highlightStyle,
        ),
      );

      start = index + query.length;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: _highlightOccurrences(query),
      ),
    );
  }
}
