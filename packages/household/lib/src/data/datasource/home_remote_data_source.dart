import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:household/src/data/dtos/project_dto.dart';

import '../../domain/domain.dart';
import '../dtos/home_dto.dart';
import '../dtos/task_dto.dart';

abstract class HomeRemoteDataSource {
  Future<GetHomesResponse> getHomes(GetHomesParams params);
  Future<DeleteHomeResponse> deleteHome(DeleteHomeParams params);
  Future<CreateHomeResponse> createHome(CreateHomeParams params);
  Future<InviteToHomeResponse> inviteToHome(InviteToHomeParams params);
  Future<JoinHomeResponse> joinHome(JoinHomeParams params);

  Future<GetTasksResponse> getTasks(GetTasksParams params);
  Future<CompleteTaskResponse> completeTask(CompleteTaskParams params);
  Future<UncompleteTaskResponse> uncompleteTask(UncompleteTaskParams params);

  Future<CreateTaskResponse> createTask(CreateTaskParams params);
  Future<DeleteTaskResponse> deleteTask(DeleteTaskParams params);
  Future<bool> needsMigration(String homeId);
  Future<void> migrate(String homeId);

  Future<GetProjectsResponse> getProjects(GetProjectsParams params);

  Future<GetTasksForProjectResponse> getTasksForProject(
      GetTasksForProjectParams params);
}

class HomeFirebaseDataSourceIMPL implements HomeRemoteDataSource {
  final _db = FirestoreUtils();
  @override
  Future<CreateHomeResponse> createHome(CreateHomeParams params) async {
    final dto = HomeDto(
        id: "",
        name: params.name,
        people: [params.userId],
        admins: [params.userId]);

    final id = (await _db.homesCollection.add(dto.toSnapshotMap())).id;

    return CreateHomeResponse(homeEntity: dto.toEntity().copyWith(id: id));
  }

  @override
  Future<DeleteHomeResponse> deleteHome(DeleteHomeParams params) async {
    await _db.homesCollection.doc(params.homeId).delete();
    return const DeleteHomeResponse();
  }

  @override
  Future<GetHomesResponse> getHomes(GetHomesParams params) async {
    final documents = (await _db.homesCollection
            .where(HomeDto.peopleField, arrayContains: params.userId)
            .get())
        .docs;
    return GetHomesResponse(
        homes:
            documents.map((e) => HomeDto.fromSnapshot(e).toEntity()).toList());
  }

  @override
  Future<InviteToHomeResponse> inviteToHome(InviteToHomeParams params) {
    throw UnimplementedError();
  }

  @override
  Future<JoinHomeResponse> joinHome(JoinHomeParams params) async {
    try {
      await _db.homesCollection.doc(params.homeId).update({
        HomeDto.peopleField: FieldValue.arrayUnion([params.userId]),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw HomeNotFoundTaskFailure();
      }
    }

    final doc = await _db.homesCollection.doc(params.homeId).get();

    return JoinHomeResponse(joinedHome: HomeDto.fromSnapshot(doc).toEntity());
  }

  @override
  Future<GetTasksResponse> getTasks(GetTasksParams params) async {
    Query<Map<String, dynamic>> collection = _db.taskCollection(params.homeId);
    collection =
        collection.where(TaskDto.typeField, isEqualTo: params.type.name);

    if (params.filters != null) {
      collection = _applyFilters(params.filters!, collection);
    }

    final documents = (await collection.get()).docs;
    return GetTasksResponse(
        tasks: documents
            .map((e) => TaskDto.fromMap(e.data(), e.id).toEntity())
            .toList());
  }

  Query<Map<String, dynamic>> _applyFilters(
      TaskFilters filters, Query<Map<String, dynamic>> collection) {
    int count = 0;
    if (filters.sortFilters.contains(TaskSortFilter.creationDate)) {
      collection =
          collection.orderBy(TaskDto.creationDateField, descending: true);
      count++;
    }
    if (filters.sortFilters.contains(TaskSortFilter.deadline)) {
      collection = collection.orderBy(TaskDto.deadlineField, descending: false);
      count++;
    }
    if (count != 2 && filters.sortFilters.contains(TaskSortFilter.importance)) {
      collection =
          collection.orderBy(TaskDto.importanceField, descending: true);
    }

    if (!filters.showCompletedTasks) {
      collection = collection.where(TaskDto.isCompletedField, isEqualTo: false);
    }

    return collection;
  }

  @override
  Future<CompleteTaskResponse> completeTask(CompleteTaskParams params) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.taskCollection(params.task.homeId);

    await collection.doc(params.task.id).update({
      TaskDto.isCompletedField: true,
    });

    return CompleteTaskResponse(
        completedTask: params.task.copyWith(isCompleted: true));
  }

  @override
  Future<UncompleteTaskResponse> uncompleteTask(
      UncompleteTaskParams params) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.taskCollection(params.task.homeId);

    await collection.doc(params.task.id).update({
      TaskDto.isCompletedField: false,
    });

    return UncompleteTaskResponse(
      uncompletedTask: params.task.copyWith(isCompleted: false),
    );
  }

  @override
  Future<CreateTaskResponse> createTask(CreateTaskParams params) async {
    final collection = _db.taskCollection(params.homeId);

    final mockEntity = TaskDto(
        homeId: params.homeId,
        id: '',
        body: params.body,
        deadline: params.deadline,
        isCompleted: false,
        importance: params.importance,
        type: params.type,
        creationDate: DateTime.now());

    final ref = await collection.add(mockEntity.toMap());

    return CreateTaskResponse(task: mockEntity.copyWith(id: ref.id).toEntity());
  }

  @override
  Future<DeleteTaskResponse> deleteTask(DeleteTaskParams params) async {
    final collection = _db.taskCollection(params.task.homeId);
    await collection.doc(params.task.id).delete();
    return const DeleteTaskResponse();
  }

  @override
  Future<void> migrate(String homeId) async {
    final chores = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(homeId)
            .collection('chore_list')
            .get())
        .docs;
    final shopping = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(homeId)
            .collection('shopping_list')
            .get())
        .docs;
    final list = [...chores, ...shopping];
    final tasks = list.map((e) => TaskDto.fromMap(e.data(), e.id)).toList();
    for (var task in tasks) {
      await _db.taskCollection(homeId).doc(task.id).set(task.toMap());
    }
  }

  @override
  Future<bool> needsMigration(String homeId) async {
    final chores = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(homeId)
            .collection('chore_list')
            .get())
        .docs;
    final shopping = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(homeId)
            .collection('shopping_list')
            .get())
        .docs;
    final tasks = (await _db.taskCollection(homeId).limit(1).get()).docs;
    return tasks.isEmpty && (chores.isNotEmpty || shopping.isNotEmpty);
  }

  @override
  Future<GetProjectsResponse> getProjects(GetProjectsParams params) async {
    final projects = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(params.homeId)
            .collection(_db.projectsCollectionName)
            .get())
        .docs;
    return GetProjectsResponse(
      projects: projects
          .map((e) => ProjectDto.fromMap(e.data(), e.id).toEntity())
          .toList(),
    );
  }

  @override
  Future<GetTasksForProjectResponse> getTasksForProject(
      GetTasksForProjectParams params) async {
    final tasks = (await FirebaseFirestore.instance
            .collection('homes')
            .doc(params.project.homeId)
            .collection(_db.projectsCollectionName)
            .doc(params.project.id)
            .collection(_db.subtasksCollectionName)
            .get())
        .docs;

    return GetTasksForProjectResponse(
        tasks: tasks
            .map((e) => TaskDto.fromMap(e.data(), e.id).toEntity())
            .toList());
  }
}

class FirestoreUtils {
  final _db = FirebaseFirestore.instance;
  final int homesLimit = 3;
  final String usersCollectionName = 'users';
  final String homesCollectionName = 'homes';
  final String projectsCollectionName = 'homes';
  final String subtasksCollectionName = 'tasks';

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _db.collection(usersCollectionName);
  CollectionReference<Map<String, dynamic>> get homesCollection =>
      _db.collection(homesCollectionName);

  CollectionReference<Map<String, dynamic>> taskCollection(String homeId) {
    return homesCollection.doc(homeId).collection('tasks');
  }
}
