import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/model/task_model.dart';

Future<void> showUpdateStatusBottomSheet({
  required BuildContext context,
  required TaskStatus currentStatus,
  ValueChanged<TaskStatus>? onStatusSelected,
}) {
  return Get.bottomSheet<void>(
    UpdateStatusBottomSheet(
      currentStatus: currentStatus,
      onStatusSelected: onStatusSelected,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

class UpdateStatusBottomSheet extends StatelessWidget {
  const UpdateStatusBottomSheet({
    super.key,
    required this.currentStatus,
    this.onStatusSelected,
  });

  final TaskStatus currentStatus;
  final ValueChanged<TaskStatus>? onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E2E8),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Update Status',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF23242D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mark your progress in this ritual',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7D808C),
            ),
          ),
          const SizedBox(height: 26),
          _StatusOptionCard(
            label: 'To-Do',
            subtitle: 'AWAITING START',
            icon: Icons.panorama_fish_eye_rounded,
            isSelected: currentStatus == TaskStatus.pending,
            onTap: () {
              onStatusSelected?.call(TaskStatus.pending);
              Get.back<void>();
            },
          ),
          const SizedBox(height: 12),
          _StatusOptionCard(
            label: 'In Progress',
            subtitle: 'CURRENT FOCUS',
            icon: Icons.autorenew_rounded,
            isSelected: currentStatus == TaskStatus.inProgress,
            onTap: () {
              onStatusSelected?.call(TaskStatus.inProgress);
              Get.back<void>();
            },
          ),
          const SizedBox(height: 12),
          _StatusOptionCard(
            label: 'Done',
            subtitle: 'TASK COMPLETE',
            icon: Icons.check_circle_outline_rounded,
            isSelected: currentStatus == TaskStatus.completed,
            onTap: () {
              onStatusSelected?.call(TaskStatus.completed);
              Get.back<void>();
            },
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Get.back<void>(),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(
              'Dismiss',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5E606D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOptionCard extends StatelessWidget {
  const _StatusOptionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? const Color(0xFF4A5BD1)
        : const Color(0xFFF4F4F6);
    final titleColor = isSelected ? Colors.white : const Color(0xFF2B2D36);
    final subtitleColor = isSelected
        ? const Color(0xFFD6DBFF)
        : const Color(0xFF9EA2AE);
    final leadingBackground = isSelected
        ? const Color(0xFF6373DE)
        : const Color(0xFFE9EBF1);
    final leadingColor = isSelected
        ? Colors.white
        : const Color(0xFF7E8391);
    final trailingColor = isSelected ? Colors.white : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x264A5BD1),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: leadingBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: leadingColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle_rounded,
                color: trailingColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
