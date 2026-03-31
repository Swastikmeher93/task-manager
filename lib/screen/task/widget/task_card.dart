import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/model/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDateLabel,
    this.progress = 0.74,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onChangeStatus,
  });

  final String title;
  final String description;
  final TaskStatus status;
  final String dueDateLabel;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onChangeStatus;

  static const double _cardRadius = 28;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5F3),
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusChip(status: status),
                  const Spacer(),
                  PopupMenuButton<_TaskCardMenuAction>(
                    tooltip: 'Task actions',
                    color: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.zero,
                    position: PopupMenuPosition.under,
                    onSelected: (value) {
                      switch (value) {
                        case _TaskCardMenuAction.edit:
                          onEdit?.call();
                          break;
                        case _TaskCardMenuAction.delete:
                          onDelete?.call();
                          break;
                        case _TaskCardMenuAction.changeStatus:
                          onChangeStatus?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem<_TaskCardMenuAction>(
                        value: _TaskCardMenuAction.edit,
                        child: _TaskCardMenuItem(
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                        ),
                      ),
                      PopupMenuItem<_TaskCardMenuAction>(
                        value: _TaskCardMenuAction.delete,
                        child: _TaskCardMenuItem(
                          icon: Icons.delete_outline_rounded,
                          label: 'Delete',
                          isDestructive: true,
                        ),
                      ),
                      PopupMenuItem<_TaskCardMenuAction>(
                        value: _TaskCardMenuAction.changeStatus,
                        child: _TaskCardMenuItem(
                          icon: Icons.sync_alt_rounded,
                          label: 'Change Status',
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEEB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.more_vert_rounded,
                        size: 18,
                        color: Color(0xFF5D5D6B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1F2128),
                  height: 1.15,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6D7280),
                  height: 1.45,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 7,
                        backgroundColor: const Color(0xFFB8F4DE),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF008062),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Due: $dueDateLabel',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF686B78),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _TaskCardMenuAction { edit, delete, changeStatus }

class _TaskCardMenuItem extends StatelessWidget {
  const _TaskCardMenuItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFC24C4C)
        : const Color(0xFF232429);

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor(status),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: _textColor(status),
        ),
      ),
    );
  }

  String _label(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'TO-DO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'DONE';
    }
  }

  Color _backgroundColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFFFFE9C7);
      case TaskStatus.inProgress:
        return const Color(0xFFD9DEFF);
      case TaskStatus.completed:
        return const Color(0xFFDDF7E9);
    }
  }

  Color _textColor(TaskStatus status) {
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
