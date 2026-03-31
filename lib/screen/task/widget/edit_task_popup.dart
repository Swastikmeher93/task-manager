import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';

Future<EditTaskResult?> showEditTaskPopup({
  required BuildContext context,
  required String initialTitle,
  required TaskStatus initialStatus,
  String initialDescription = '',
  DateTime? initialDueDate,
  int? initialBlockedByTaskId,
  List<TaskModel> blockedByOptions = const [],
}) async {
  final tag = UniqueKey().toString();
  final result = await Get.dialog<EditTaskResult>(
    EditTaskPopup(
      controllerTag: tag,
      initialTitle: initialTitle,
      initialDescription: initialDescription,
      initialStatus: initialStatus,
      initialDueDate: initialDueDate,
      initialBlockedByTaskId: initialBlockedByTaskId,
      blockedByOptions: blockedByOptions,
    ),
    barrierDismissible: true,
  );
  if (Get.isRegistered<_EditTaskPopupController>(tag: tag)) {
    Get.delete<_EditTaskPopupController>(tag: tag);
  }
  return result;
}

class EditTaskResult {
  const EditTaskResult({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.blockedByTaskId,
  });

  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final int? blockedByTaskId;
}

class EditTaskPopup extends StatelessWidget {
  EditTaskPopup({
    super.key,
    required this.controllerTag,
    required this.initialTitle,
    required this.initialStatus,
    this.initialDescription = '',
    this.initialDueDate,
    this.initialBlockedByTaskId,
    this.blockedByOptions = const [],
  }) {
    Get.put(
      _EditTaskPopupController(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
        initialStatus: initialStatus,
        initialDueDate: initialDueDate,
        initialBlockedByTaskId: initialBlockedByTaskId,
        blockedByOptions: blockedByOptions,
      ),
      tag: controllerTag,
    );
  }

  final String controllerTag;
  final String initialTitle;
  final String initialDescription;
  final TaskStatus initialStatus;
  final DateTime? initialDueDate;
  final int? initialBlockedByTaskId;
  final List<TaskModel> blockedByOptions;

  _EditTaskPopupController get _controller =>
      Get.find<_EditTaskPopupController>(tag: controllerTag);

  Future<void> _pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDueDate.value ?? DateTime.now(),
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
    _controller.setDueDate(picked);
  }

  void _save(BuildContext context) {
    final title = _controller.titleController.text.trim();
    final description = _controller.descriptionController.text.trim();
    final dueDate = _controller.selectedDueDate.value;

    if (title.isEmpty || description.isEmpty || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title, description, and due date.'),
        ),
      );
      return;
    }

    Get.back<EditTaskResult>(
      result: EditTaskResult(
        title: title,
        description: description,
        dueDate: dueDate,
        status: _controller.selectedStatus.value,
        blockedByTaskId: _controller.selectedBlockedByTaskId.value,
      ),
    );
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Done';
    }
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
                                  onPressed: () => Get.back<void>(),
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
                  const _PopupLabel(text: 'TASK TITLE'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _controller.titleController,
                    hintText: 'What needs attention?',
                  ),
                  const SizedBox(height: 14),
                  const _PopupLabel(text: 'DETAILED DESCRIPTION'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _controller.descriptionController,
                    hintText: 'Add a few details...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  const _PopupLabel(text: 'DUE DATE'),
                  const SizedBox(height: 8),
                  _PopupTextField(
                    controller: _controller.dueDateController,
                    hintText: 'Select due date',
                    readOnly: true,
                    onTap: () => _pickDueDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF4254D0),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _PopupLabel(text: 'TASK STATUS'),
                  const SizedBox(height: 8),
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskStatus>(
                          value: _controller.selectedStatus.value,
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
                            _controller.selectedStatus.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _PopupLabel(text: 'BLOCKED BY'),
                  const SizedBox(height: 8),
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: _controller.selectedBlockedByTaskId.value,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('No dependency'),
                            ),
                            ..._controller.blockedByOptions.map((task) {
                              return DropdownMenuItem<int?>(
                                value: task.id,
                                child: Text(
                                  task.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            _controller.selectedBlockedByTaskId.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_controller.selectedBlockedByTaskId.value == null) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
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
                              'This task depends on another task from your list and should be completed after that one.',
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
                    );
                  }),
                  const SizedBox(height: 34),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back<void>(),
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
                          onPressed: () => _save(context),
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
}

class _EditTaskPopupController extends GetxController {
  _EditTaskPopupController({
    required String initialTitle,
    required String initialDescription,
    required TaskStatus initialStatus,
    required DateTime? initialDueDate,
    required int? initialBlockedByTaskId,
    required this.blockedByOptions,
  }) : selectedStatus = initialStatus.obs,
       selectedDueDate = Rxn<DateTime>(initialDueDate),
       selectedBlockedByTaskId = RxnInt(initialBlockedByTaskId) {
    titleController = TextEditingController(text: initialTitle);
    descriptionController = TextEditingController(text: initialDescription);
    dueDateController = TextEditingController(
      text: initialDueDate == null
          ? ''
          : DateFormat('MMM d, yyyy').format(initialDueDate),
    );
  }

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController dueDateController;
  final Rx<TaskStatus> selectedStatus;
  final Rxn<DateTime> selectedDueDate;
  final RxnInt selectedBlockedByTaskId;
  final List<TaskModel> blockedByOptions;

  void setDueDate(DateTime dueDate) {
    selectedDueDate.value = dueDate;
    dueDateController.text = DateFormat('MMM d, yyyy').format(dueDate);
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.onClose();
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
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
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
