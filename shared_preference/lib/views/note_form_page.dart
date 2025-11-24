import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preference/controllers/note_controller.dart';
import 'package:shared_preference/models/note_model.dart';

class NoteFormPage extends StatelessWidget {
  final NoteModel? note;
  final titleC = TextEditingController();
  final contentC = TextEditingController();

  NoteFormPage({super.key, this.note}) {
    if (note != null) {
      titleC.text = note!.title;
      contentC.text = note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteC = Get.find<NoteController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? "Tambah Catatan" : "Edit Catatan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: contentC,
              decoration: const InputDecoration(labelText: "Isi Catatan"),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(note == null ? "Simpan" : "Update"),
              onPressed: () {
                if (note == null) {
                  noteC.addNote(titleC.text, contentC.text);
                } else {
                  noteC.updateNote(note!.id!, titleC.text, contentC.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}