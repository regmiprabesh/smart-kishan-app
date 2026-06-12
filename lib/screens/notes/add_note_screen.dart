import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/models/note.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _noteTitleController = TextEditingController();
  final _noteDescriptionController = TextEditingController();
  final _notePriorityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Note selectedNote = Note();

  @override
  void initState() {
    super.initState();
    if (noteController.isEdit.value) {
      selectedNote = noteController.selectedNote.value;
      _noteTitleController.text = selectedNote.title ?? '';
      _noteDescriptionController.text = selectedNote.description ?? '';
      _notePriorityController.text = selectedNote.priority?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteDescriptionController.dispose();
    _notePriorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = noteController.isEdit.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          isEdit ? l10n.updateNote : l10n.addNote,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.noteTitle,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                InputTextField(
                  textEditingController: _noteTitleController,
                  title: l10n.enterNoteTitle,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterNoteTitle;
                    }
                    if (value.length < 3) {
                      return l10n.noteTitleMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.noteDescription,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                InputTextField(
                  textEditingController: _noteDescriptionController,
                  title: l10n.enterNoteDescription,
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.notePriority,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                InputTextField(
                  textEditingController: _notePriorityController,
                  title: l10n.enterNotePriority,
                  textInputType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(20)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize:
                        Size(double.infinity, getProportionateScreenWidth(40)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (isEdit) {
                        noteController.updateNote(Note(
                          id: selectedNote.id!,
                          title: _noteTitleController.text,
                          description: _noteDescriptionController.text,
                          priority: int.tryParse(_notePriorityController.text),
                        ));
                      } else {
                        noteController.addNote(
                          Note(
                            title: _noteTitleController.text,
                            description: _noteDescriptionController.text,
                            priority:
                                int.tryParse(_notePriorityController.text),
                            date: DateTime.now().toString(),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(isEdit ? l10n.update : l10n.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
