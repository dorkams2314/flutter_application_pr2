import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _inputFocus = FocusNode();
  final _notes = <String>[];
  int? _editingIndex;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final text = _textController.text.trim();
    setState(() {
      if (_editingIndex case final index?) {
        _notes[index] = text;
      } else {
        _notes.add(text);
      }
      _editingIndex = null;
    });
    _formKey.currentState!.reset();
    _textController.clear();
    _inputFocus.unfocus();
  }

  void _editNote(int index) {
    _formKey.currentState!.reset();
    setState(() {
      _editingIndex = index;
      _textController.text = _notes[index];
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    });
    _scrollController.jumpTo(0);
    _inputFocus.requestFocus();
  }

  void _cancelEditing() {
    setState(() => _editingIndex = null);
    _formKey.currentState!.reset();
    _textController.clear();
    _inputFocus.unfocus();
  }

  void _deleteNote(int index) {
    if (_editingIndex == index) {
      _cancelEditing();
    }
    setState(() {
      _notes.removeAt(index);
      if (_editingIndex case final editingIndex? when index < editingIndex) {
        _editingIndex = editingIndex - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _textController,
                        focusNode: _inputFocus,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: _editingIndex == null
                              ? 'New note'
                              : 'Edit note',
                          hintText: 'Enter your note here',
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please enter a note.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _saveNote,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          _editingIndex == null ? 'Save' : 'Save changes',
                        ),
                      ),
                      if (_editingIndex != null)
                        TextButton(
                          onPressed: _cancelEditing,
                          child: const Text('Cancel'),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        'Your notes (${_notes.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_notes.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No notes yet. Write a note and tap Save.'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(_notes[index]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  tooltip: 'Edit note',
                                  onPressed: () => _editNote(index),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Delete note',
                                  onPressed: () => _deleteNote(index),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
