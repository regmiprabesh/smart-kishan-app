import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          l10n.notes,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Obx(() => noteController.notes.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizedNumber(noteController.notes.length),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          noteController.isEdit(false);
          Get.toNamed(AppRoute.addNoteScreen);
        },
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          l10n.newNote,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
      ),
      body: Obx(
        () => noteController.notes.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: ((context, index) {
                  final note = noteController.notes[index];
                  return _buildNoteCard(context, note, index);
                }),
                itemCount: noteController.notes.length,
              )
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, note, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              noteController.isEdit(true);
              noteController.selectedNote(note);
              Get.toNamed(AppRoute.addNoteScreen);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          note.title ?? '',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(15),
                            color: const Color(0xFF1a1a1a),
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildActionButtons(context, note, index),
                    ],
                  ),

                  // Description
                  if (note.description != null &&
                      note.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        note.description!,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],

                  // Footer with metadata
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        // Date
                        if (note.date != null) ...[
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(note.date!),
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(11),
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        // Added by (if applicable)
                        if ((authController.user.value!.parentId == null ||
                                authController.user.value!.parentId == 0) &&
                            note.user != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              note.user!.name ?? '',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(11),
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, note, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit Button
        Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.edit_rounded,
              size: 20,
              color: kPrimaryColor,
            ),
            onPressed: () {
              noteController.isEdit(true);
              noteController.selectedNote(note);
              Get.toNamed(AppRoute.addNoteScreen);
            },
            tooltip: l10n.edit,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 8),
        // Delete Button
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              size: 20,
              color: Colors.red,
            ),
            onPressed: () => _showDeleteDialog(context, note),
            tooltip: l10n.delete,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, note) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.confirmDelete,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.deleteNoteConfirm,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.all(16),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                noteController.deleteNote(note.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_add_rounded,
                size: 64,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            Text(
              l10n.noNotesMsg,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              l10n.notesEmptyDescription,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenHeight(32)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(32),
                  vertical: getProportionateScreenHeight(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                noteController.isEdit(false);
                Get.toNamed(AppRoute.addNoteScreen);
              },
              icon: const Icon(Icons.add_rounded, size: 24),
              label: Text(
                l10n.addNote,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) return l10n.today;
      if (difference.inDays == 1) return l10n.yesterday;
      if (difference.inDays < 7) {
        return l10n.daysAgo(localizedNumber(difference.inDays));
      }
      return DateFormat('d/M/yyyy', localeCode).format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
