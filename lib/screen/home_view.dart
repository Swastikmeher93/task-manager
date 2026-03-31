import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/task/add_task_view.dart';
import 'package:task_manager/screen/task/task_details_page.dart';
import 'package:task_manager/screen/task/widget/delete_task_popup.dart';
import 'package:task_manager/screen/task/widget/edit_task_popup.dart';
import 'package:task_manager/screen/task/widget/task_card.dart';
import 'package:task_manager/screen/task/widget/update_status_bottomsheet.dart';
import 'package:task_manager/services/home_ui_controller.dart';
import 'package:task_manager/services/task_controller.dart';
import 'package:task_manager/widget/app_logo.dart';

class HomeView extends GetView<TaskController> {
  const HomeView({super.key});

  HomeUiController get _homeUiController => Get.find<HomeUiController>();

  Future<void> _handleAddTask() async {
    controller.clearForm();
    await Get.to<void>(() => const AddTaskView());
  }

  Future<void> _handleEditTask(BuildContext context, TaskModel task) async {
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
    messenger.showSnackBar(
      SnackBar(content: Text('Updated "${editedTask.title}"')),
    );
  }

  Future<void> _handleDeleteTask(BuildContext context, TaskModel task) async {
    await showDeleteTaskPopup(
      context: context,
      taskTitle: task.title,
      onDelete: () async {
        final messenger = ScaffoldMessenger.of(context);
        final taskId = task.id;
        if (taskId == null) return;

        await controller.deleteTask(taskId);
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Deleted "${task.title}"')),
        );
      },
    );
  }

  Future<void> _handleStatusChange(BuildContext context, TaskModel task) async {
    final messenger = ScaffoldMessenger.of(context);
    await showUpdateStatusBottomSheet(
      context: context,
      currentStatus: task.status,
      onStatusSelected: (status) async {
        await controller.updateTaskStatus(task: task, status: status);
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Status for "${task.title}" changed to ${_statusLabel(status)}',
            ),
          ),
        );
      },
    );
  }

  String get _formattedCurrentDate {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM d').format(now).toUpperCase();
  }

  String _formatDueDate(DateTime dueDate) {
    return DateFormat('MMM d').format(dueDate);
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
        return 'to-do';
      case TaskStatus.inProgress:
        return 'in progress';
      case TaskStatus.completed:
        return 'done';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final hasNoTasks = controller.tasks.isEmpty;
        final hasNoMatches = controller.filteredTasks.isEmpty;

        return RefreshIndicator(
          onRefresh: controller.loadTasks,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                pinned: false,
                floating: false,
                snap: false,
                expandedHeight: 92,
                toolbarHeight: 82,
                titleSpacing: 16,
                title: Row(
                  children: [
                    const AppLogo(size: 42),
                    const SizedBox(width: 12),
                    Text(
                      'Task Management',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: const Color(0xFF15161E),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      _formattedCurrentDate,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: const Color(0xFF24389C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daily Focus',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF15161E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: Color(0xFF8D93A6),
                          ),
                          hintText: 'Search your tasks',
                          hintStyle: GoogleFonts.manrope(
                            color: const Color(0xFF8D93A6),
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          suffixIcon: controller.searchQuery.value.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.onSearchChanged('');
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: Color(0xFF8D93A6),
                                  ),
                                ),
                        ),
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF15161E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              if (controller.isLoading.value && hasNoTasks)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (hasNoTasks)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(onCreateTask: _handleAddTask),
                )
              else if (hasNoMatches)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No tasks match your search.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6D7280),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 18);
                      }

                      final task = controller.filteredTasks[index ~/ 2];
                      final isActivelyBlocked = controller
                          .isTaskActivelyBlocked(task);
                      final blockedByText = task.blockedBy == null
                          ? null
                          : controller.blockedByLabel(task.blockedBy);

                      return TaskCard(
                        title: task.title,
                        description: task.description,
                        blockedByText: isActivelyBlocked ? blockedByText : null,
                        isBlocked: isActivelyBlocked,
                        status: task.status,
                        dueDateLabel: _formatDueDate(task.dueDate),
                        progress: _progressFor(task.status),
                        onEdit: () => _handleEditTask(context, task),
                        onDelete: () => _handleDeleteTask(context, task),
                        onChangeStatus: () =>
                            _handleStatusChange(context, task),
                        onTap: () {
                          if (isActivelyBlocked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'This task is blocked by "$blockedByText" and cannot be opened yet.',
                                ),
                              ),
                            );
                            return;
                          }
                          final taskId = task.id;
                          if (taskId == null) return;
                          Get.to<void>(() => TaskDetailsPage(taskId: taskId));
                        },
                      );
                    }, childCount: controller.filteredTasks.length * 2 - 1),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(
        () => AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          offset: _homeUiController.showFab.value
              ? Offset.zero
              : const Offset(0, 1.35),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            scale: _homeUiController.showFab.value ? 1 : 0.9,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: _homeUiController.showFab.value ? 1 : 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2624389C),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: _handleAddTask,
                    borderRadius: BorderRadius.circular(999),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                      width: _homeUiController.collapseFab.value ? 74 : 172,
                      height: 74,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5169EE), Color(0xFF3048B8)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: _homeUiController.showFabLabel.value
                                  ? 1
                                  : 0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  right: 8,
                                ),
                                child: Text(
                                  'Add Task',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                            width: 62,
                            height: 62,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF4059D6),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTask});

  final Future<void> Function() onCreateTask;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFE9EDFF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.checklist_rounded,
                size: 40,
                color: Color(0xFF3048B8),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No tasks yet',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF15161E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first task and it will appear here from the local database.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6F7381),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
