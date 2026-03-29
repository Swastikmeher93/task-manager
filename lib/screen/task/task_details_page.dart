import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/task/widget/edit_task_popup.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({
    super.key,
    required this.title,
    required this.status,
    required this.dueDateLabel,
    required this.progress,
  });

  final String title;
  final TaskStatus status;
  final String dueDateLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                showEditTaskPopup(
                  context: context,
                  initialTitle: title,
                  initialStatus: status,
                );
              },
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF15161E)),
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
                color: _statusBackground(status),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _statusLabel(status),
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: _statusText(status),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
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
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
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
}
