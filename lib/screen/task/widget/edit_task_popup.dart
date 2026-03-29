import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';

Future<void> showEditTaskPopup({
  required BuildContext context,
  required String initialTitle,
  required TaskStatus initialStatus,
  String initialDescription = '',
  DateTime? initialDueDate,
  VoidCallback? onSave,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return EditTaskPopup(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
        initialStatus: initialStatus,
        initialDueDate: initialDueDate,
        onSave: onSave,
      );
    },
  );
}

class EditTaskPopup extends StatefulWidget {
  const EditTaskPopup({
    super.key,
    required this.initialTitle,
    required this.initialStatus,
    this.initialDescription = '',
    this.initialDueDate,
    this.onSave,
  });

  final String initialTitle;
  final String initialDescription;
  final TaskStatus initialStatus;
  final DateTime? initialDueDate;
  final VoidCallback? onSave;

  @override
  State<EditTaskPopup> createState() => _EditTaskPopupState();
}

class _EditTaskPopupState extends State<EditTaskPopup> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueDateController;
  late TaskStatus _selectedStatus;

  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _selectedStatus = widget.initialStatus;
    _selectedDueDate = widget.initialDueDate;
    _dueDateController = TextEditingController(
      text: widget.initialDueDate == null
          ? ''
          : DateFormat('MMM d, yyyy').format(widget.initialDueDate!),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B50C1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF15161E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _selectedDueDate = picked;
      _dueDateController.text = DateFormat('MMM d, yyyy').format(picked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.82;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 420),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFF8FBFF)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A172554),
                blurRadius: 34,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ACTION\nCENTER',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                                height: 1.25,
                                color: const Color(0xFF5A6BFF),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Edit Task',
                              style: GoogleFonts.manrope(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                                color: const Color(0xFF20212A),
                                height: 0.95,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                3,
                                (_) => Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  width: 34,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1EFF2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 22,
                                    color: Color(0xFF535663),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Transform.rotate(
                                  angle: -0.75,
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 34,
                                    color: Color(0xFFE9E7ED),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _PopupLabel(text: 'TASK TITLE'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _titleController,
                    hintText: 'What needs attention?',
                  ),
                  const SizedBox(height: 14),
                  _PopupLabel(text: 'DETAILED DESCRIPTION'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _descriptionController,
                    hintText: 'Add a few details...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  _PopupLabel(text: 'DUE DATE'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _dueDateController,
                    hintText: 'Select due date',
                    readOnly: true,
                    onTap: _pickDueDate,
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF4254D0),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PopupLabel(text: 'TASK STATUS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<TaskStatus>(
                        value: _selectedStatus,
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF7280C8),
                          ),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF22242C),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: TaskStatus.values.map((status) {
                          return DropdownMenuItem<TaskStatus>(
                            value: status,
                            child: Text(_statusLabel(status)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PopupLabel(text: 'BLOCKED BY'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Task #102: Budget Approval from Finance',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4A4D5A),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.link_rounded,
                          size: 18,
                          color: Color(0xFF5868D8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 15,
                          color: Color(0xFFBE6B5B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'This task cannot be completed until the selected dependency is resolved.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB15F4F),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'DISCARD',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                              color: const Color(0xFF7A7E8C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onSave?.call();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4456D8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: const Color(0x334456D8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save\nChanges',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

class _PopupLabel extends StatelessWidget {
  const _PopupLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.3,
        color: const Color(0xFF989CA9),
      ),
    );
  }
}

class _PopupTextField extends StatelessWidget {
  const _PopupTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF22242C),
          height: 1.45,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA5A7B4),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
