import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;

  NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =TextEditingController();
  File? imageFile;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.title;
      _base64Image = widget.note!.imageBase64;
    }
  }

Future<void> pickImage() async {
  final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64String = base64Encode(bytes);
      setState(() {
        _base64Image = base64String;
        imageFile = File(pickedFile.path);
      });
      print("Base64 Image: $_base64Image");
    }else {
      print("No image selected");
    }

  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Tambah Note' : 'Edit Note'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pilih Gambar'),
            ),
            if (imageFile != null)
              Image.file(imageFile!, height: 100),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: saveNote,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
  Future<void> saveNote() async {

  // kalau pakai base64
  String? imageBase64 = _base64Image;

  Note note = Note(
    id: widget.note?.id,
    title: _titleController.text,
    description: _descriptionController.text,
    imageBase64: imageBase64,
    createdAt: widget.note?.createdAt,
  );

  if (widget.note == null) {
    await NoteService.addNote(note);
  } else {
    await NoteService.updateNote(note);
  }

  Navigator.pop(context);
}


//
  }