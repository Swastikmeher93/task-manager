import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/task/add_task_view.dart';
import 'package:task_manager/screen/task/task_details_page.dart';
import 'package:task_manager/screen/task/widget/task_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showFab = false;
  bool _collapseFab = false;
  final List<
    ({String title, TaskStatus status, String dueDate, double progress})
  >
  _sampleTasks = [
    (
      title: 'Finalise Project',
      status: TaskStatus.inProgress,
      dueDate: 'Oct 12',
      progress: 0.74,
    ),
    (
      title: 'Plan Weekly Sprint',
      status: TaskStatus.pending,
      dueDate: 'Oct 14',
      progress: 0.28,
    ),
    (
      title: 'Review Team Updates',
      status: TaskStatus.completed,
      dueDate: 'Oct 10',
      progress: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _showFab = true;
      });

      Future<void>.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        setState(() {
          _collapseFab = true;
        });
      });
    });
  }

  String get _formattedCurrentDate {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM d').format(now).toUpperCase();
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
        title: Text(
          'Task Management',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: const Color(0xFF15161E),
          ),
        ),
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
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _sampleTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final task = _sampleTasks[index];

                  return TaskCard(
                    title: task.title,
                    status: task.status,
                    dueDateLabel: task.dueDate,
                    progress: task.progress,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TaskDetailsPage(
                            title: task.title,
                            status: task.status,
                            dueDateLabel: task.dueDate,
                            progress: task.progress,
                          ),
                        ),
                      );
                    },
                  );
                },
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddTaskView(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    width: _collapseFab ? 74 : 156,
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: _collapseFab ? 0 : 1,
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                            padding: EdgeInsets.only(
                              left: _collapseFab ? 0 : 18,
                              right: _collapseFab ? 0 : 56,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Add Task',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF4059D6),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
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
