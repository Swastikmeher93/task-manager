import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/task/widget/edit_task_popup.dart';
import 'package:task_manager/services/task_controller.dart';

class TaskDetailsPage extends GetView<TaskController> {
  const TaskDetailsPage({super.key, required this.taskId});

  final int taskId;

  Future<void> _editTask(BuildContext context, TaskModel task) async {
    final messenger = ScaffoldMessenger.of(context);
    final editedTask = await showEditTaskPopup(
      context: context,
      initialTitle: task.title,
      initialDescription: task.description,
      initialStatus: task.status,
      initialDueDate: task.dueDate,
      initialBlockedByTaskId: task.blockedBy,
      blockedByOptions: controller.availableBlockedByOptions(
        excludingTaskId: task.id,
      ),
    );

    if (editedTask == null) return;

    await controller.updateTask(
      TaskModel(
        id: task.id,
        title: editedTask.title,
        description: editedTask.description,
        dueDate: editedTask.dueDate,
        status: editedTask.status,
        blockedBy: editedTask.blockedByTaskId,
      ),
    );

    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text('Updated "${editedTask.title}"')));
  }

  double _progressFor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 0.2;
      case TaskStatus.inProgress:
        return 0.6;
      case TaskStatus.completed:
        return 1;
    }
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'TO-DO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'DONE';
    }
  }

  Color _statusBackground(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFFFFE9C7);
      case TaskStatus.inProgress:
        return const Color(0xFFD9DEFF);
      case TaskStatus.completed:
        return const Color(0xFFDDF7E9);
    }
  }

  Color _statusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFF9A6500);
      case TaskStatus.inProgress:
        return const Color(0xFF5664C7);
      case TaskStatus.completed:
        return const Color(0xFF117A48);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final task = controller.getTaskById(taskId);

      if (task == null) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            title: const Text('Task Details'),
          ),
          body: const Center(
            child: Text('This task is no longer available.'),
          ),
        );
      }

      final progress = _progressFor(task.status);
      final dueDateLabel = DateFormat('MMM d, yyyy').format(task.dueDate);
      final blockedByLabel = controller.blockedByLabel(task.blockedBy);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            'Task Details',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF15161E),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () => _editTask(context, task),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF15161E),
                ),
                tooltip: 'Edit task',
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusBackground(task.status),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusLabel(task.status),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: _statusText(task.status),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                task.title,
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF15161E),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Due $dueDateLabel',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF24389C),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Blocked By',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF15161E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                blockedByLabel,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5F6472),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF15161E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5F6472),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Progress',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF15161E),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 10,
                  backgroundColor: const Color(0xFFB8F4DE),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF008062),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(progress * 100).round()}% complete',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF707382),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
