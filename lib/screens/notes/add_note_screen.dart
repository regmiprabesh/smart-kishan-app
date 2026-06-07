import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
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

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kSecondaryColor;
    }
    return kPrimaryColor;
  }

  @override
  void initState() {
    if (noteController.isEdit.value) {
      setState(() {
        selectedNote = noteController.selectedNote.value;
      });
      _noteTitleController.text = selectedNote.title!;
      _noteDescriptionController.text = selectedNote.description!;
      _notePriorityController.text =
          selectedNote.priority != null ? selectedNote.priority.toString() : '';
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
            noteController.isEdit.value
                ? 'नोट अपडेट गर्नुहोस्'
                : 'नोट थप्नुहोस्',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  'नोटको शीर्षक',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _noteTitleController,
                  title: 'नोटको शीर्षक प्रविष्टि गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया आफ्नो नोटको शीर्षक प्रविष्टि गर्नुहोस्';
                    }
                    if (value.length < 3) {
                      return "नोटको शीर्षक कम्तिमा पनि ३ अक्षरको हुनुपर्छ";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'नोटको विवरण',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _noteDescriptionController,
                  title: 'नोटको विवरण प्रविष्टि गर्नुहोस्',
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'नोटको प्राथमिकता',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _notePriorityController,
                  title: 'नोटको प्राथमिकता प्रविष्टि गर्नुहोस्',
                  textInputType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenWidth(20),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: Size(
                          double.infinity, getProportionateScreenWidth(40))),
                  child: noteController.isEdit.value
                      ? const Text('अपडेट गर्नुहोस्')
                      : const Text('थप्नुहोस्'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (noteController.isEdit.value) {
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
                            false);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
