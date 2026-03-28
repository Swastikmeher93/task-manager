import 'package:flutter/material.dart';
import 'package:task_manager/model/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.status,
    required this.dueDateLabel,
    this.progress = 0.74,
    this.onTap,
    this.onMorePressed,
  });

  final String title;
  final TaskStatus status;
  final String dueDateLabel;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

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
                  InkWell(
                    onTap: onMorePressed,
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: Color(0xFF5D5D6B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232429),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 22),
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
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
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
