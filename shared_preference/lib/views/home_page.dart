import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preference/controllers/auth_controller.dart';
import 'package:shared_preference/controllers/note_controller.dart';
import 'package:shared_preference/models/note_model.dart';
import 'package:shared_preference/views/note_form_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final auth = Get.find<AuthController>();
  final noteC = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan Applikasi"),
        actions: [
          IconButton(onPressed: () => auth.logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: Obx(() {
        if (noteC.notes.isEmpty) {
          return const Center(child: Text("Belum ada catatan"));
        }
        return ListView.builder(
          itemCount: noteC.notes.length,
          itemBuilder: (_, i) {
            final NoteModel note = noteC.notes[i];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(
                note.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // Corrected route to pass note for editing
                Get.to(() => NoteFormPage(note: note));
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => noteC.deleteNote(note.id!),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => NoteFormPage());
        },
      ),
    );
  }
}