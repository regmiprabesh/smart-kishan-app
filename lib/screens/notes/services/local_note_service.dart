import 'package:smart_kishan/models/note.dart';
import 'package:smart_kishan/repositories/repository.dart';

class LocalNoteService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //create note
  saveNote(Note note) async {
    return await _repository.insertData('notes', note.toJson());
  }

  //read note
  readNotes() async {
    return await _repository.readData('notes');
  }

  //read note by id
  readNoteById(noteId) async {
    return await _repository.readDataById('notes', noteId);
  }

  //read note by id
  updateNote(Note note) async {
    return await _repository.updateData('notes', note.toJson());
  }

  //delete note
  deleteNote(noteId) async {
    return await _repository.deleteData('notes', noteId);
  }
}
