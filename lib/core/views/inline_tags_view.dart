import 'package:flutter/material.dart';

import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'package:gitjournal/core/processors/inline_tags.dart';
import 'package:gitjournal/core/transformers/base.dart';
import 'notes_materialized_view.dart';

typedef InlineTagsView = NotesMaterializedView<List<String>>;

class InlineTagsProvider extends SingleChildStatelessWidget {
  final String repoPath;

  InlineTagsProvider({
    Key? key,
    Widget? child,
    required this.repoPath,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider(
      create: (_) {
        return NotesMaterializedView<List<String>>(
          name: 'inline_tags',
          repoPath: repoPath,
          computeFn: _compute,
        );
      },
      child: child,
    );
  }

  static InlineTagsView of(BuildContext context) {
    return Provider.of<InlineTagsView>(context);
  }
}

Future<List<String>> _compute(Note note) async {
  var tagPrefixes = note.parent.config.inlineTagPrefixes;
  var p = InlineTagsProcessor(tagPrefixes: tagPrefixes);
  return p.extractTags(note.body).toList();
}
