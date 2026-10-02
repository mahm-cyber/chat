/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class ConversationModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ConversationModel._({
    this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageText,
    this.lastMessageSentAt,
    required this.unreadCountUser1,
    required this.unreadCountUser2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel({
    int? id,
    required int user1Id,
    required int user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    required int unreadCountUser1,
    required int unreadCountUser2,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ConversationModelImpl;

  factory ConversationModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConversationModel(
      id: jsonSerialization['id'] as int?,
      user1Id: jsonSerialization['user1Id'] as int,
      user2Id: jsonSerialization['user2Id'] as int,
      lastMessageText: jsonSerialization['lastMessageText'] as String?,
      lastMessageSentAt: jsonSerialization['lastMessageSentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageSentAt'],
            ),
      unreadCountUser1: jsonSerialization['unreadCountUser1'] as int,
      unreadCountUser2: jsonSerialization['unreadCountUser2'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ConversationModelTable();

  static const db = ConversationModelRepository._();

  @override
  int? id;

  int user1Id;

  int user2Id;

  String? lastMessageText;

  DateTime? lastMessageSentAt;

  int unreadCountUser1;

  int unreadCountUser2;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ConversationModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ConversationModel copyWith({
    int? id,
    int? user1Id,
    int? user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    int? unreadCountUser1,
    int? unreadCountUser2,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConversationModel',
      if (id != null) 'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      if (lastMessageText != null) 'lastMessageText': lastMessageText,
      if (lastMessageSentAt != null)
        'lastMessageSentAt': lastMessageSentAt?.toJson(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConversationModel',
      if (id != null) 'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      if (lastMessageText != null) 'lastMessageText': lastMessageText,
      if (lastMessageSentAt != null)
        'lastMessageSentAt': lastMessageSentAt?.toJson(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ConversationModelInclude include() {
    return ConversationModelInclude._();
  }

  static ConversationModelIncludeList includeList({
    _is.WhereExpressionBuilder<ConversationModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    ConversationModelInclude? include,
  }) {
    return ConversationModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationModelImpl extends ConversationModel {
  _ConversationModelImpl({
    int? id,
    required int user1Id,
    required int user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    required int unreadCountUser1,
    required int unreadCountUser2,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         user1Id: user1Id,
         user2Id: user2Id,
         lastMessageText: lastMessageText,
         lastMessageSentAt: lastMessageSentAt,
         unreadCountUser1: unreadCountUser1,
         unreadCountUser2: unreadCountUser2,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ConversationModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ConversationModel copyWith({
    Object? id = _Undefined,
    int? user1Id,
    int? user2Id,
    Object? lastMessageText = _Undefined,
    Object? lastMessageSentAt = _Undefined,
    int? unreadCountUser1,
    int? unreadCountUser2,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationModel(
      id: id is int? ? id : this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      lastMessageText: lastMessageText is String?
          ? lastMessageText
          : this.lastMessageText,
      lastMessageSentAt: lastMessageSentAt is DateTime?
          ? lastMessageSentAt
          : this.lastMessageSentAt,
      unreadCountUser1: unreadCountUser1 ?? this.unreadCountUser1,
      unreadCountUser2: unreadCountUser2 ?? this.unreadCountUser2,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ConversationModelUpdateTable
    extends _is.UpdateTable<ConversationModelTable> {
  ConversationModelUpdateTable(super.table);

  _is.ColumnValue<int, int> user1Id(int value) => _is.ColumnValue(
    table.user1Id,
    value,
  );

  _is.ColumnValue<int, int> user2Id(int value) => _is.ColumnValue(
    table.user2Id,
    value,
  );

  _is.ColumnValue<String, String> lastMessageText(String? value) =>
      _is.ColumnValue(
        table.lastMessageText,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastMessageSentAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastMessageSentAt,
        value,
      );

  _is.ColumnValue<int, int> unreadCountUser1(int value) => _is.ColumnValue(
    table.unreadCountUser1,
    value,
  );

  _is.ColumnValue<int, int> unreadCountUser2(int value) => _is.ColumnValue(
    table.unreadCountUser2,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ConversationModelTable extends _is.Table<int?> {
  ConversationModelTable({super.tableRelation})
    : super(tableName: 'conversation') {
    updateTable = ConversationModelUpdateTable(this);
    user1Id = _is.ColumnInt(
      'user1Id',
      this,
    );
    user2Id = _is.ColumnInt(
      'user2Id',
      this,
    );
    lastMessageText = _is.ColumnString(
      'lastMessageText',
      this,
    );
    lastMessageSentAt = _is.ColumnDateTime(
      'lastMessageSentAt',
      this,
    );
    unreadCountUser1 = _is.ColumnInt(
      'unreadCountUser1',
      this,
    );
    unreadCountUser2 = _is.ColumnInt(
      'unreadCountUser2',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ConversationModelUpdateTable updateTable;

  late final _is.ColumnInt user1Id;

  late final _is.ColumnInt user2Id;

  late final _is.ColumnString lastMessageText;

  late final _is.ColumnDateTime lastMessageSentAt;

  late final _is.ColumnInt unreadCountUser1;

  late final _is.ColumnInt unreadCountUser2;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    user1Id,
    user2Id,
    lastMessageText,
    lastMessageSentAt,
    unreadCountUser1,
    unreadCountUser2,
    createdAt,
    updatedAt,
  ];
}

class ConversationModelInclude extends _is.IncludeObject {
  ConversationModelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ConversationModel.t;
}

class ConversationModelIncludeList extends _is.IncludeList {
  ConversationModelIncludeList._({
    _is.WhereExpressionBuilder<ConversationModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ConversationModel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ConversationModel.t;
}

class ConversationModelRepository {
  const ConversationModelRepository._();

  /// Returns a list of [ConversationModel]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ConversationModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConversationModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ConversationModel>(
      where: where?.call(ConversationModel.t),
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ConversationModel] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ConversationModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConversationModelTable>? where,
    int? offset,
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ConversationModel>(
      where: where?.call(ConversationModel.t),
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ConversationModel] by its [id] or null if no such row exists.
  Future<ConversationModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ConversationModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ConversationModel]s in the list and returns the inserted rows.
  ///
  /// The returned [ConversationModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> insert(
    _is.DatabaseSession session,
    List<ConversationModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ConversationModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ConversationModel] and returns the inserted row.
  ///
  /// The returned [ConversationModel] will have its `id` field set.
  Future<ConversationModel> insertRow(
    _is.DatabaseSession session,
    ConversationModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ConversationModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ConversationModel]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ConversationModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> upsert(
    _is.DatabaseSession session,
    List<ConversationModel> rows, {
    required _is.ColumnSelections<ConversationModelTable> conflictColumns,
    _is.ColumnSelections<ConversationModelTable>? updateColumns,
    _is.WhereExpressionBuilder<ConversationModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ConversationModel>(
      rows,
      conflictColumns: conflictColumns(ConversationModel.t),
      updateColumns: updateColumns?.call(ConversationModel.t),
      updateWhere: updateWhere?.call(ConversationModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ConversationModel] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ConversationModel] will have its `id` field set.
  Future<ConversationModel?> upsertRow(
    _is.DatabaseSession session,
    ConversationModel row, {
    required _is.ColumnSelections<ConversationModelTable> conflictColumns,
    _is.ColumnSelections<ConversationModelTable>? updateColumns,
    _is.WhereExpressionBuilder<ConversationModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ConversationModel>(
      row,
      conflictColumns: conflictColumns(ConversationModel.t),
      updateColumns: updateColumns?.call(ConversationModel.t),
      updateWhere: updateWhere?.call(ConversationModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [ConversationModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> update(
    _is.DatabaseSession session,
    List<ConversationModel> rows, {
    _is.ColumnSelections<ConversationModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ConversationModel>(
      rows,
      columns: columns?.call(ConversationModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ConversationModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ConversationModel> updateRow(
    _is.DatabaseSession session,
    ConversationModel row, {
    _is.ColumnSelections<ConversationModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ConversationModel>(
      row,
      columns: columns?.call(ConversationModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ConversationModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ConversationModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ConversationModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ConversationModel>(
      id,
      columnValues: columnValues(ConversationModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ConversationModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ConversationModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ConversationModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ConversationModel>(
      columnValues: columnValues(ConversationModel.t.updateTable),
      where: where(ConversationModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ConversationModel]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> delete(
    _is.DatabaseSession session,
    List<ConversationModel> rows, {
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ConversationModel>(
      rows,
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ConversationModel].
  Future<ConversationModel> deleteRow(
    _is.DatabaseSession session,
    ConversationModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ConversationModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ConversationModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ConversationModelTable> where,
    _is.OrderByBuilder<ConversationModelTable>? orderBy,
    _is.OrderByListBuilder<ConversationModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ConversationModel>(
      where: where(ConversationModel.t),
      orderBy: orderBy?.call(ConversationModel.t),
      orderByList: orderByList?.call(ConversationModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ConversationModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ConversationModel>(
      where: where?.call(ConversationModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ConversationModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ConversationModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ConversationModel>(
      where: where(ConversationModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
