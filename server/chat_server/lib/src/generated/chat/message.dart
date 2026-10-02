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
import 'package:chat_server/src/generated/protocol.dart' as _i2wttstz;
import 'package:serverpod/serverpod.dart' as _is;

abstract class MessageModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MessageModel._({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.attachmentUrls,
    required this.status,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
  });

  factory MessageModel({
    int? id,
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
    required String status,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) = _MessageModelImpl;

  factory MessageModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageModel(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      senderId: jsonSerialization['senderId'] as int,
      recipientId: jsonSerialization['recipientId'] as int,
      content: jsonSerialization['content'] as String,
      attachmentUrls: jsonSerialization['attachmentUrls'] == null
          ? null
          : _i2wttstz.Protocol().deserialize<List<String>>(
              jsonSerialization['attachmentUrls'],
            ),
      status: jsonSerialization['status'] as String,
      sentAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
    );
  }

  static final t = MessageModelTable();

  static const db = MessageModelRepository._();

  @override
  int? id;

  int conversationId;

  int senderId;

  int recipientId;

  String content;

  List<String>? attachmentUrls;

  String status;

  DateTime sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MessageModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MessageModel copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    int? recipientId,
    String? content,
    List<String>? attachmentUrls,
    String? status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MessageModel',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      if (attachmentUrls != null) 'attachmentUrls': attachmentUrls?.toJson(),
      'status': status,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MessageModel',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      if (attachmentUrls != null) 'attachmentUrls': attachmentUrls?.toJson(),
      'status': status,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  static MessageModelInclude include() {
    return MessageModelInclude._();
  }

  static MessageModelIncludeList includeList({
    _is.WhereExpressionBuilder<MessageModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    MessageModelInclude? include,
  }) {
    return MessageModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageModelImpl extends MessageModel {
  _MessageModelImpl({
    int? id,
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
    required String status,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         senderId: senderId,
         recipientId: recipientId,
         content: content,
         attachmentUrls: attachmentUrls,
         status: status,
         sentAt: sentAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
       );

  /// Returns a shallow copy of this [MessageModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MessageModel copyWith({
    Object? id = _Undefined,
    int? conversationId,
    int? senderId,
    int? recipientId,
    String? content,
    Object? attachmentUrls = _Undefined,
    String? status,
    DateTime? sentAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
  }) {
    return MessageModel(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      attachmentUrls: attachmentUrls is List<String>?
          ? attachmentUrls
          : this.attachmentUrls?.map((e0) => e0).toList(),
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
    );
  }
}

class MessageModelUpdateTable extends _is.UpdateTable<MessageModelTable> {
  MessageModelUpdateTable(super.table);

  _is.ColumnValue<int, int> conversationId(int value) => _is.ColumnValue(
    table.conversationId,
    value,
  );

  _is.ColumnValue<int, int> senderId(int value) => _is.ColumnValue(
    table.senderId,
    value,
  );

  _is.ColumnValue<int, int> recipientId(int value) => _is.ColumnValue(
    table.recipientId,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> attachmentUrls(
    List<String>? value,
  ) => _is.ColumnValue(
    table.attachmentUrls,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> sentAt(DateTime value) => _is.ColumnValue(
    table.sentAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> deliveredAt(DateTime? value) =>
      _is.ColumnValue(
        table.deliveredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _is.ColumnValue(
        table.readAt,
        value,
      );
}

class MessageModelTable extends _is.Table<int?> {
  MessageModelTable({super.tableRelation}) : super(tableName: 'message') {
    updateTable = MessageModelUpdateTable(this);
    conversationId = _is.ColumnInt(
      'conversationId',
      this,
    );
    senderId = _is.ColumnInt(
      'senderId',
      this,
    );
    recipientId = _is.ColumnInt(
      'recipientId',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    attachmentUrls = _is.ColumnSerializable<List<String>>(
      'attachmentUrls',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    sentAt = _is.ColumnDateTime(
      'sentAt',
      this,
    );
    deliveredAt = _is.ColumnDateTime(
      'deliveredAt',
      this,
    );
    readAt = _is.ColumnDateTime(
      'readAt',
      this,
    );
  }

  late final MessageModelUpdateTable updateTable;

  late final _is.ColumnInt conversationId;

  late final _is.ColumnInt senderId;

  late final _is.ColumnInt recipientId;

  late final _is.ColumnString content;

  late final _is.ColumnSerializable<List<String>> attachmentUrls;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime sentAt;

  late final _is.ColumnDateTime deliveredAt;

  late final _is.ColumnDateTime readAt;

  @override
  List<_is.Column> get columns => [
    id,
    conversationId,
    senderId,
    recipientId,
    content,
    attachmentUrls,
    status,
    sentAt,
    deliveredAt,
    readAt,
  ];
}

class MessageModelInclude extends _is.IncludeObject {
  MessageModelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MessageModel.t;
}

class MessageModelIncludeList extends _is.IncludeList {
  MessageModelIncludeList._({
    _is.WhereExpressionBuilder<MessageModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MessageModel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MessageModel.t;
}

class MessageModelRepository {
  const MessageModelRepository._();

  /// Returns a list of [MessageModel]s matching the given query parameters.
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
  Future<List<MessageModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MessageModel>(
      where: where?.call(MessageModel.t),
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MessageModel] matching the given query parameters.
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
  Future<MessageModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageModelTable>? where,
    int? offset,
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MessageModel>(
      where: where?.call(MessageModel.t),
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MessageModel] by its [id] or null if no such row exists.
  Future<MessageModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MessageModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MessageModel]s in the list and returns the inserted rows.
  ///
  /// The returned [MessageModel]s will have their `id` fields set.
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
  Future<List<MessageModel>> insert(
    _is.DatabaseSession session,
    List<MessageModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MessageModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MessageModel] and returns the inserted row.
  ///
  /// The returned [MessageModel] will have its `id` field set.
  Future<MessageModel> insertRow(
    _is.DatabaseSession session,
    MessageModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MessageModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MessageModel]s in the list and returns the resulting rows.
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
  /// The returned [MessageModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageModel>> upsert(
    _is.DatabaseSession session,
    List<MessageModel> rows, {
    required _is.ColumnSelections<MessageModelTable> conflictColumns,
    _is.ColumnSelections<MessageModelTable>? updateColumns,
    _is.WhereExpressionBuilder<MessageModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MessageModel>(
      rows,
      conflictColumns: conflictColumns(MessageModel.t),
      updateColumns: updateColumns?.call(MessageModel.t),
      updateWhere: updateWhere?.call(MessageModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MessageModel] and returns the resulting row.
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
  /// The returned [MessageModel] will have its `id` field set.
  Future<MessageModel?> upsertRow(
    _is.DatabaseSession session,
    MessageModel row, {
    required _is.ColumnSelections<MessageModelTable> conflictColumns,
    _is.ColumnSelections<MessageModelTable>? updateColumns,
    _is.WhereExpressionBuilder<MessageModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MessageModel>(
      row,
      conflictColumns: conflictColumns(MessageModel.t),
      updateColumns: updateColumns?.call(MessageModel.t),
      updateWhere: updateWhere?.call(MessageModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [MessageModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageModel>> update(
    _is.DatabaseSession session,
    List<MessageModel> rows, {
    _is.ColumnSelections<MessageModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MessageModel>(
      rows,
      columns: columns?.call(MessageModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MessageModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MessageModel> updateRow(
    _is.DatabaseSession session,
    MessageModel row, {
    _is.ColumnSelections<MessageModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MessageModel>(
      row,
      columns: columns?.call(MessageModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MessageModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MessageModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MessageModelUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MessageModel>(
      id,
      columnValues: columnValues(MessageModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MessageModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MessageModelUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MessageModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MessageModel>(
      columnValues: columnValues(MessageModel.t.updateTable),
      where: where(MessageModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MessageModel]s in the list and returns the deleted rows.
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
  Future<List<MessageModel>> delete(
    _is.DatabaseSession session,
    List<MessageModel> rows, {
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MessageModel>(
      rows,
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MessageModel].
  Future<MessageModel> deleteRow(
    _is.DatabaseSession session,
    MessageModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MessageModel>(
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
  Future<List<MessageModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MessageModelTable> where,
    _is.OrderByBuilder<MessageModelTable>? orderBy,
    _is.OrderByListBuilder<MessageModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MessageModel>(
      where: where(MessageModel.t),
      orderBy: orderBy?.call(MessageModel.t),
      orderByList: orderByList?.call(MessageModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MessageModel>(
      where: where?.call(MessageModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MessageModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MessageModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MessageModel>(
      where: where(MessageModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
