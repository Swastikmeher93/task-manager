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
        completedAt: task.completedAt,
      ),
    );

    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text('Updated "${editedTask.title}"')));
  }

  Future<void> _completeTask(BuildContext context, TaskModel task) async {
    final messenger = ScaffoldMessenger.of(context);
    await controller.updateTaskStatus(
      task: task,
      status: TaskStatus.completed,
    );
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text('"${task.title}" marked as done')),
    );
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'IN QUEUE';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'DONE';
    }
  }

  Color _statusBackground(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFFEDEBFF);
      case TaskStatus.inProgress:
        return const Color(0xFFE7E8FF);
      case TaskStatus.completed:
        return const Color(0xFFE4F6EB);
    }
  }

  Color _statusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFF6660C8);
      case TaskStatus.inProgress:
        return const Color(0xFF5851C9);
      case TaskStatus.completed:
        return const Color(0xFF13764B);
    }
  }

  String _priorityLabel(TaskModel task) {
    final now = DateTime.now();
    final daysLeft = task.dueDate.difference(now).inDays;
    if (task.status == TaskStatus.completed) return 'DONE';
    if (daysLeft <= 2) return 'HIGH';
    if (daysLeft <= 7) return 'MEDIUM';
    return 'LOW';
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'HIGH':
        return const Color(0xFFB55B4B);
      case 'MEDIUM':
        return const Color(0xFF897B22);
      case 'LOW':
        return const Color(0xFF4E8A6F);
      case 'DONE':
        return const Color(0xFF4E8A6F);
      default:
        return const Color(0xFF7B7F90);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final task = controller.getTaskById(taskId);

      if (task == null) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: SafeArea(
            child: Center(
              child: Text(
                'This task is no longer available.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF73798B),
                ),
              ),
            ),
          ),
        );
      }

      final dueDateLabel = DateFormat('MMM d, yyyy').format(task.dueDate);
      final blockedByLabel = controller.blockedByLabel(task.blockedBy);
      final priorityLabel = _priorityLabel(task);

      return Scaffold(
        backgroundColor: const Color(0xFFF7F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back<void>(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF3F438D),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Task Sanctuary',
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3B3D92),
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDF8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: TextButton.icon(
                        onPressed: () => _editTask(context, task),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          foregroundColor: const Color(0xFF6A64D8),
                        ),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBackground(task.status),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel(task.status),
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.9,
                          color: _statusText(task.status),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'PRIORITY: $priorityLabel',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                        color: _priorityColor(priorityLabel).withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  task.title,
                  style: GoogleFonts.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF3B3D92),
                    height: 1.08,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  task.description,
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666C7B),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                _DetailInfoCard(
                  background: const Color(0xFFF0F0F5),
                  icon: Icons.event_note_rounded,
                  iconBackground: const Color(0xFFF5F2FF),
                  iconColor: const Color(0xFF685BE7),
                  label: 'DUE DATE',
                  value: dueDateLabel,
                ),
                const SizedBox(height: 14),
                _DetailInfoCard(
                  background: const Color(0xFFF0F1F5),
                  icon: Icons.block_rounded,
                  iconBackground: const Color(0xFFE6E8EE),
                  iconColor: const Color(0xFF737B8E),
                  label: 'BLOCKED BY',
                  value: 'this task title',
                  subtitle: blockedByLabel == 'No dependency'
                      ? 'Not blocked by any task'
                      : blockedByLabel,
                  valueColor: const Color(0xFF4D5463),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: SizedBox(
            height: 62,
            child: FilledButton.icon(
              onPressed: task.status == TaskStatus.completed
                  ? null
                  : () => _completeTask(context, task),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3A4BB8),
                disabledBackgroundColor: const Color(0xFFB9C1E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                shadowColor: const Color(0x333A4BB8),
              ),
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: Text(
                task.status == TaskStatus.completed
                    ? 'Task Completed'
                    : 'Complete Task',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _DetailInfoCard extends StatelessWidget {
  const _DetailInfoCard({
    required this.background,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor = const Color(0xFF454B60),
  });

  final Color background;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;
  final String? subtitle;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.15,
                    color: valueColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: valueColor.withValues(alpha: 0.78),
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
