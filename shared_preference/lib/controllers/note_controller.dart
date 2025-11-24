import 'package:get/get.dart';
import 'package:shared_preference/database/db_helper.dart';
import 'package:shared_preference/models/note_model.dart';

class NoteController extends GetxController {
  var notes = <NoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      notes.value = await DBHelper.getNotes();
    } catch (e) {
      print('loadNotes error: $e');
      notes.value = [];
    }
  }

  Future<void> addNote(String title, String content) async {
    await DBHelper.addNote(NoteModel(title: title, content: content));
    await loadNotes();
    Get.back();
  }

  Future<void> updateNote(int id, String title, String content) async {
    await DBHelper.updateNote(
      NoteModel(id: id, title: title, content: content),
    );
    await loadNotes();
    Get.back();
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    await loadNotes();
  }
}