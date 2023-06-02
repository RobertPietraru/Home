import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class FirestoreUtils {
  final _db = FirebaseFirestore.instance;
  final int homesLimit = 3;
  final String usersCollectionName = 'users';
  final String homesCollectionName = 'homes';

  final String shoppingListCollectionName = 'shopping_list';
  final String choreListCollectionName = 'chore_list';

  final String tasksCollectionName = 'tasks';

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _db.collection(usersCollectionName);
  CollectionReference<Map<String, dynamic>> get homesCollection =>
      _db.collection(homesCollectionName);

  CollectionReference<Map<String, dynamic>> getChoresListForHome(
      String homeId) {
    return homesCollection.doc(homeId).collection(choreListCollectionName);
  }

  CollectionReference<Map<String, dynamic>> getListForHome(
      String homeId, TaskType type) {
    if (type == TaskType.chore) {
      return getChoresListForHome(homeId);
    } else {
      return getShoppingListForHome(homeId);
    }
  }

  CollectionReference<Map<String, dynamic>> getShoppingListForHome(
      String homeId) {
    return homesCollection.doc(homeId).collection(shoppingListCollectionName);
  }
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
        homes: documents.map((e) => HomeDto.fromSnapshot(e).toEntity()).toList());
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
    late final collection = _db.getListForHome(params.homeId, params.type);

    final documents = (await collection.get()).docs;
    return GetTasksResponse(
        tasks: documents
            .map((e) => TaskDto.fromMap(e.data(), e.id).toEntity())
            .toList());
  }

  @override
  Future<CompleteTaskResponse> completeTask(CompleteTaskParams params) async {
    late final CollectionReference<Map<String, dynamic>> collection;
    if (params.task.type == TaskType.chore) {
      collection = _db.getChoresListForHome(params.task.homeId);
    } else {
      collection = _db.getShoppingListForHome(params.task.homeId);
    }

    await collection.doc(params.task.id).update({
      TaskDto.isCompletedField: true,
    });

    return CompleteTaskResponse(
        completedTask: params.task.copyWith(isCompleted: true));
  }

  @override
  Future<UncompleteTaskResponse> uncompleteTask(
      UncompleteTaskParams params) async {
    late final CollectionReference<Map<String, dynamic>> collection;
    if (params.task.type == TaskType.chore) {
      collection = _db.getChoresListForHome(params.task.homeId);
    } else {
      collection = _db.getShoppingListForHome(params.task.homeId);
    }

    await collection.doc(params.task.id).update({
      TaskDto.isCompletedField: false,
    });

    return UncompleteTaskResponse(
      uncompletedTask: params.task.copyWith(isCompleted: false),
    );
  }

  @override
  Future<CreateTaskResponse> createTask(CreateTaskParams params) async {
    final collection = _db.getListForHome(params.homeId, params.type);

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
    final collection = _db.getListForHome(params.task.homeId, params.task.type);
    await collection.doc(params.task.id).delete();
    return const DeleteTaskResponse();
  }
}
