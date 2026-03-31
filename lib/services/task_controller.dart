import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/database_service.dart';

class TaskController extends GetxController {
  TaskController({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxnString errorMessage = RxnString();
  final RxString searchQuery = ''.obs;
  final Rx<TaskStatus> selectedStatus = TaskStatus.pending.obs;
  final Rxn<DateTime> selectedDueDate = Rxn<DateTime>();
  final RxnInt selectedBlockedByTaskId = RxnInt();
  Worker? _searchDebounceWorker;

  int get taskCount => tasks.length;

  @override
  void onInit() {
    super.onInit();
    _searchDebounceWorker = debounce<String>(
      searchQuery,
      (query) => searchFromDB(query),
      time: const Duration(milliseconds: 350),
    );
    loadTasks();
  }

  Future<void> loadTasks() async {
    await _runDatabaseAction(() async {
      final storedTasks = await _databaseService.getTasks();
      tasks.assignAll(storedTasks);
      filteredTasks.assignAll(storedTasks);
    });
  }

  Future<void> searchFromDB(String query) async {
    await _runDatabaseAction(() async {
      if (query.trim().isEmpty) {
        filteredTasks.assignAll(tasks);
        return;
      }

      final results = await _databaseService.searchTasks(query);
      filteredTasks.assignAll(results);
    });
  }

  Future<int?> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
    TaskStatus status = TaskStatus.pending,
    int? blockedBy,
  }) async {
    int? taskId;

    await _runDatabaseAction(() async {
      final task = TaskModel(
        title: title.trim(),
        description: description.trim(),
        dueDate: dueDate,
        status: status,
        blockedBy: blockedBy,
      );

      taskId = await _databaseService.insertTask(task);
      await _refreshTasks();
    });

    return taskId;
  }

  Future<int?> createTaskFromForm() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final dueDate = selectedDueDate.value;

    if (title.isEmpty || description.isEmpty || dueDate == null) {
      return null;
    }

    try {
      isSaving.value = true;
      return await createTask(
        title: title,
        description: description,
        dueDate: dueDate,
        status: selectedStatus.value,
        blockedBy: selectedBlockedByTaskId.value,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<int?> updateTask(TaskModel task) async {
    int? rowsAffected;

    await _runDatabaseAction(() async {
      rowsAffected = await _databaseService.updateTask(task);
      await _refreshTasks();
    });

    return rowsAffected;
  }

  Future<int?> updateTaskStatus({
    required TaskModel task,
    required TaskStatus status,
  }) async {
    return updateTask(
      TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        status: status,
        blockedBy: task.blockedBy,
      ),
    );
  }

  Future<int?> deleteTask(int id) async {
    int? rowsAffected;

    await _runDatabaseAction(() async {
      final dependentTasks = tasks
          .where((task) => task.blockedBy == id)
          .toList();
      for (final task in dependentTasks) {
        await _databaseService.updateTask(
          TaskModel(
            id: task.id,
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            status: task.status,
            blockedBy: null,
          ),
        );
      }

      rowsAffected = await _databaseService.deleteTask(id);
      await _refreshTasks();
    });

    return rowsAffected;
  }

  TaskModel? getTaskById(int id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TaskModel> availableBlockedByOptions({int? excludingTaskId}) {
    return tasks
        .where((task) => task.id != null && task.id != excludingTaskId)
        .toList();
  }

  String blockedByLabel(int? taskId, {String fallback = 'No dependency'}) {
    if (taskId == null) return fallback;
    final task = getTaskById(taskId);
    return task == null ? 'Task #$taskId' : task.title;
  }

  void fillForm(TaskModel task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    dueDateController.text = _formatDate(task.dueDate);
    selectedDueDate.value = task.dueDate;
    selectedStatus.value = task.status;
    selectedBlockedByTaskId.value = task.blockedBy;
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    selectedDueDate.value = null;
    selectedStatus.value = TaskStatus.pending;
    selectedBlockedByTaskId.value = null;
  }

  void setSelectedStatus(TaskStatus status) {
    selectedStatus.value = status;
  }

  void setSelectedDueDate(DateTime dueDate) {
    selectedDueDate.value = dueDate;
    dueDateController.text = _formatDate(dueDate);
  }

  void setSelectedBlockedByTaskId(int? taskId) {
    selectedBlockedByTaskId.value = taskId;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<void> _refreshTasks() async {
    final storedTasks = await _databaseService.getTasks();
    tasks.assignAll(storedTasks);
    final query = searchController.text.trim();
    if (query.isEmpty) {
      filteredTasks.assignAll(storedTasks);
    } else {
      final results = await _databaseService.searchTasks(query);
      filteredTasks.assignAll(results);
    }
  }

  Future<void> _runDatabaseAction(Future<void> Function() action) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      await action();
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _searchDebounceWorker?.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    searchController.dispose();
    super.onClose();
  }

  String _formatDate(DateTime dueDate) {
    final month = dueDate.month.toString().padLeft(2, '0');
    final day = dueDate.day.toString().padLeft(2, '0');
    return '$month/$day/${dueDate.year}';
  }
}
