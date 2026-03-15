import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';

class MobileNoteTextEditor extends StatefulWidget {
  const MobileNoteTextEditor({
    super.key,
    required this.currentContent,
    required this.onContentChanged,
  });

  final String currentContent;
  final ValueChanged<String> onContentChanged;

  @override
  State<MobileNoteTextEditor> createState() => _MobileNoteTextEditorState();
}

class _MobileNoteTextEditorState extends State<MobileNoteTextEditor> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(MobileNoteTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentContent != widget.currentContent) {
      _updateControllerFromNote();
    }
  }

  void _initializeController() {
    if (widget.currentContent.isNotEmpty) {
      try {
        final content = jsonDecode(widget.currentContent);
        _controller = QuillController(
          document: Document.fromJson(content),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }

    _controller.addListener(_onTextChanged);
  }

  void _updateControllerFromNote() {
    if (widget.currentContent.isEmpty) {
      _controller.document = Document();
      return;
    }

    try {
      final content = jsonDecode(widget.currentContent);
      final currentContent = jsonEncode(
        _controller.document.toDelta().toJson(),
      );

      if (currentContent != widget.currentContent) {
        _controller.document = Document.fromJson(content);
      }
    } catch (e) {
      _controller.document = Document();
    }
  }

  void _onTextChanged() {
    widget.onContentChanged(
      jsonEncode(_controller.document.toDelta().toJson()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: QuillEditor.basic(
              controller: _controller,
              focusNode: _focusNode,
              config: QuillEditorConfig(
                padding: const EdgeInsets.symmetric(vertical: 8),
                scrollable: true,
                autoFocus: false,
                expands: true,
                placeholder: 'Start writing...',
                customStyles: DefaultStyles(
                  placeHolder: DefaultTextBlockStyle(
                    textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.35),
                    ),
                    const HorizontalSpacing(0, 0),
                    const VerticalSpacing(6, 0),
                    const VerticalSpacing(0, 0),
                    null,
                  ),
                  paragraph: DefaultTextBlockStyle(
                    textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.6,
                    ),
                    const HorizontalSpacing(0, 0),
                    const VerticalSpacing(6, 0),
                    const VerticalSpacing(0, 0),
                    null,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                multiRowsDisplay: false,
                showAlignmentButtons: false,
                showBackgroundColorButton: false,
                showCenterAlignment: false,
                showCodeBlock: false,
                showDirection: false,
                showFontFamily: false,
                showFontSize: false,
                showIndent: false,
                showInlineCode: false,
                showJustifyAlignment: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                showColorButton: false,
                showSmallButton: false,
                showLink: false,
                showQuote: true,
                showHeaderStyle: false,
                showListBullets: true,
                showListNumbers: true,
                showListCheck: false,
                showStrikeThrough: false,
                showUndo: true,
                showRedo: true,
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        color: colorScheme.primary,
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  QuillController get controller => _controller;
}
