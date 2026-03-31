import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/task/add_task_view.dart';
import 'package:task_manager/screen/task/task_details_page.dart';
import 'package:task_manager/screen/task/widget/delete_task_popup.dart';
import 'package:task_manager/screen/task/widget/edit_task_popup.dart';
import 'package:task_manager/screen/task/widget/task_card.dart';
import 'package:task_manager/screen/task/widget/update_status_bottomsheet.dart';
import 'package:task_manager/services/database_service.dart';
import 'package:task_manager/widget/app_logo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _fabReplayGap = Duration(seconds: 10);
  static const _fabCollapseDelay = Duration(milliseconds: 1400);
  static const _fabLabelRevealDelay = Duration(milliseconds: 220);

  bool _showFab = false;
  bool _collapseFab = false;
  bool _showFabLabel = false;
  bool _isLoading = true;
  List<TaskModel> _tasks = const [];
  Timer? _fabReplayTimer;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playFabAnimation();
      _fabReplayTimer = Timer.periodic(_fabReplayGap, (_) {
        _playFabAnimation();
      });
    });
  }

  void _playFabAnimation() {
    if (!mounted) return;

    setState(() {
      _showFab = true;
      _collapseFab = false;
      _showFabLabel = false;
    });

    Future<void>.delayed(_fabLabelRevealDelay, () {
      if (!mounted || _collapseFab) return;
      setState(() {
        _showFabLabel = true;
      });
    });

    Future<void>.delayed(_fabCollapseDelay, () {
      if (!mounted) return;
      setState(() {
        _showFabLabel = false;
        _collapseFab = true;
      });
    });
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await DatabaseService.instance.getTasks();

    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _handleAddTask() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddTaskView()));

    await _loadTasks();
  }

  Future<void> _handleEditTask(TaskModel task) async {
    final editedTask = await showEditTaskPopup(
      context: context,
      initialTitle: task.title,
      initialDescription: task.description,
      initialStatus: task.status,
      initialDueDate: task.dueDate,
    );

    if (editedTask == null) return;

    await DatabaseService.instance.updateTask(
      TaskModel(
        id: task.id,
        title: editedTask.title,
        description: editedTask.description,
        dueDate: editedTask.dueDate,
        status: editedTask.status,
        blockedBy: task.blockedBy,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated "${editedTask.title}"')),
    );
    await _loadTasks();
  }

  Future<void> _handleDeleteTask(TaskModel task) async {
    await showDeleteTaskPopup(
      context: context,
      taskTitle: task.title,
      onDelete: () async {
        final taskId = task.id;
        if (taskId == null) return;

        await DatabaseService.instance.deleteTask(taskId);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted "${task.title}"')));
        await _loadTasks();
      },
    );
  }

  Future<void> _handleStatusChange(TaskModel task) async {
    await showUpdateStatusBottomSheet(
      context: context,
      currentStatus: task.status,
      onStatusSelected: (status) async {
        await DatabaseService.instance.updateTask(
          TaskModel(
            id: task.id,
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            status: status,
            blockedBy: task.blockedBy,
          ),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status for "${task.title}" changed to ${_statusLabel(status)}',
            ),
          ),
        );
        await _loadTasks();
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
  void dispose() {
    _fabReplayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
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
        toolbarHeight: 82,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Color(0xFF8D93A6)),
                  const SizedBox(width: 8),
                  Text(
                    'Search your tasks',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF8D93A6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _tasks.isEmpty
                    ? _EmptyState(onCreateTask: _handleAddTask)
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: _tasks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final task = _tasks[index];

                            return TaskCard(
                              title: task.title,
                              description: task.description,
                              status: task.status,
                              dueDateLabel: _formatDueDate(task.dueDate),
                              progress: _progressFor(task.status),
                              onEdit: () => _handleEditTask(task),
                              onDelete: () => _handleDeleteTask(task),
                              onChangeStatus: () => _handleStatusChange(task),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => TaskDetailsPage(task: task),
                                  ),
                                );
                                await _loadTasks();
                              },
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        offset: _showFab ? Offset.zero : const Offset(0, 1.35),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          scale: _showFab ? 1 : 0.9,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 280),
            opacity: _showFab ? 1 : 0,
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
                    width: _collapseFab ? 74 : 172,
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
                            opacity: _showFabLabel ? 1 : 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18, right: 8),
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
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                onCreateTask();
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3048B8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
