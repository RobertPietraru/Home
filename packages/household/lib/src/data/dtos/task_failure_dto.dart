import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:household/src/domain/failures/backend/aborted_task_failure.dart';
import 'package:household/src/domain/failures/backend/internal_task_failure.dart';
import 'package:household/src/domain/failures/backend/invalid_input_task_failure.dart';
import 'package:household/src/domain/failures/backend/missing_authentication_task_failure.dart';
import 'package:household/src/domain/failures/backend/missing_permissions_task_failure.dart';
import 'package:household/src/domain/failures/unknown_task_failure.dart';

import '../../domain/domain.dart';

class TaskFailureDto {
  static TaskFailure fromFirebaseException(FirebaseException exception) {
    final errors = {
      'aborted': const AbortedTaskFailure(),
      'already-exists': InternalTaskFailure(code: exception.code),
      'cancelled': InternalTaskFailure(code: exception.code),
      'data-loss': InternalTaskFailure(code: exception.code),
      'deadline-exceeded': InternalTaskFailure(code: exception.code),
      'failed-precondition': InternalTaskFailure(code: exception.code),
      'internal': InternalTaskFailure(code: exception.code),
      'invalid-argument': const InvalidInputTaskFailure(),
      'not-found': InternalTaskFailure(code: exception.code),
      'out-of-range': InternalTaskFailure(code: exception.code),
      'permission-denied': MissingPermissionsTaskFailure(code: exception.code),
      'resource-exhausted': InternalTaskFailure(code: exception.code),
      'unauthenticated': const MissingAuthenticationTaskFailure(),
      'unavailable': InternalTaskFailure(code: exception.code),
      'unimplemented': InternalTaskFailure(code: exception.code),
      'unknow': const UnknownTaskFailure(),
    };
    return errors[exception.code] ?? UnknownTaskFailure(code: exception.code);
  }
}
