import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';
import 'package:notes/widgets/note_dialog.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => NoteDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: NoteService.getNotesList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Note> notes = snapshot.data!;

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            Note note = notes[index];
            return ListTile(
              title: note.title.isNotEmpty
                  ? Text(note.title)
                  : const Text("No Title"),
              subtitle: Text(note.description),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => NoteDialog(note: note),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  NoteService.deleteNote(note);
                },
              ),
            );
          },
        );
      },
    );
  }
}