import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/task_controller.dart';

class AddTaskView extends GetView<TaskController> {
  const AddTaskView({super.key});

  Widget _buildLabel(String text, {bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 24),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: const Color(0xFF595C67),
            ),
          ),
          if (isOptional)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                '(optional)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFA5A7B4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextEditingController? controller,
    Color hintColor = const Color(0xFFA5A7B4),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBECEF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: hintColor,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF15161E),
        ),
      ),
    );
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDueDate.value ?? DateTime.now(),
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

    if (selectedDate == null) return;
    controller.setSelectedDueDate(selectedDate);
  }

  Future<void> _saveTask(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final taskId = await controller.createTaskFromForm();

    if (!context.mounted) return;
    if (taskId == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a title, description, and due date.'),
        ),
      );
      return;
    }

    final savedTitle = controller.titleController.text.trim();
    controller.clearForm();
    Get.back<void>();
    messenger.showSnackBar(SnackBar(content: Text('Saved "$savedTitle"')));
  }

  void _close() {
    controller.clearForm();
    Get.back<void>();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF15161E)),
          onPressed: _close,
        ),
        title: Text(
          'Add Task',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF15161E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Ritual',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3B50C1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Define your intention and set your focus for today.',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF595C67),
                height: 1.4,
              ),
            ),
            _buildLabel('TASK TITLE'),
            _buildTextField(
              hint: 'What is your focus?',
              controller: controller.titleController,
            ),
            _buildLabel('DESCRIPTION'),
            _buildTextField(
              hint: 'Add more details about this ritual...',
              maxLines: 4,
              controller: controller.descriptionController,
            ),
            _buildLabel('DUE DATE'),
            _buildTextField(
              hint: 'mm/dd/yyyy',
              hintColor: const Color(0xFF15161E),
              prefixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF3B50C1),
                size: 20,
              ),
              readOnly: true,
              controller: controller.dueDateController,
              onTap: () => _pickDueDate(context),
            ),
            _buildLabel('CURRENT STATUS'),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBECEF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskStatus>(
                    value: controller.selectedStatus.value,
                    isExpanded: true,
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(_statusLabel(status)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      controller.setSelectedStatus(value);
                    },
                  ),
                ),
              ),
            ),
            _buildLabel('BLOCKED BY', isOptional: true),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBECEF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: controller.selectedBlockedByTaskId.value,
                    isExpanded: true,
                    hint: const Text('No dependency'),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('No dependency'),
                      ),
                      ...controller.availableBlockedByOptions().map((task) {
                        return DropdownMenuItem<int?>(
                          value: task.id,
                          child: Text(
                            task.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: controller.setSelectedBlockedByTaskId,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F42A6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2F42A6).withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.isSaving.value
                        ? null
                        : () => _saveTask(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 22,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isSaving.value ? 'Saving...' : 'Save Task',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
