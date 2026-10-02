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

abstract class AppTranslation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AppTranslation._({
    this.id,
    required this.locale,
    required this.key,
    required this.value,
    required this.version,
    required this.updatedAt,
  });

  factory AppTranslation({
    int? id,
    required String locale,
    required String key,
    required String value,
    required int version,
    required DateTime updatedAt,
  }) = _AppTranslationImpl;

  factory AppTranslation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppTranslation(
      id: jsonSerialization['id'] as int?,
      locale: jsonSerialization['locale'] as String,
      key: jsonSerialization['key'] as String,
      value: jsonSerialization['value'] as String,
      version: jsonSerialization['version'] as int,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AppTranslationTable();

  static const db = AppTranslationRepository._();

  @override
  int? id;

  String locale;

  String key;

  String value;

  int version;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppTranslation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AppTranslation copyWith({
    int? id,
    String? locale,
    String? key,
    String? value,
    int? version,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppTranslation',
      if (id != null) 'id': id,
      'locale': locale,
      'key': key,
      'value': value,
      'version': version,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppTranslation',
      if (id != null) 'id': id,
      'locale': locale,
      'key': key,
      'value': value,
      'version': version,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AppTranslationInclude include() {
    return AppTranslationInclude._();
  }

  static AppTranslationIncludeList includeList({
    _is.WhereExpressionBuilder<AppTranslationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    AppTranslationInclude? include,
  }) {
    return AppTranslationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppTranslationImpl extends AppTranslation {
  _AppTranslationImpl({
    int? id,
    required String locale,
    required String key,
    required String value,
    required int version,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         locale: locale,
         key: key,
         value: value,
         version: version,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppTranslation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AppTranslation copyWith({
    Object? id = _Undefined,
    String? locale,
    String? key,
    String? value,
    int? version,
    DateTime? updatedAt,
  }) {
    return AppTranslation(
      id: id is int? ? id : this.id,
      locale: locale ?? this.locale,
      key: key ?? this.key,
      value: value ?? this.value,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AppTranslationUpdateTable extends _is.UpdateTable<AppTranslationTable> {
  AppTranslationUpdateTable(super.table);

  _is.ColumnValue<String, String> locale(String value) => _is.ColumnValue(
    table.locale,
    value,
  );

  _is.ColumnValue<String, String> key(String value) => _is.ColumnValue(
    table.key,
    value,
  );

  _is.ColumnValue<String, String> value(String value) => _is.ColumnValue(
    table.value,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AppTranslationTable extends _is.Table<int?> {
  AppTranslationTable({super.tableRelation})
    : super(tableName: 'app_translation') {
    updateTable = AppTranslationUpdateTable(this);
    locale = _is.ColumnString(
      'locale',
      this,
    );
    key = _is.ColumnString(
      'key',
      this,
    );
    value = _is.ColumnString(
      'value',
      this,
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final AppTranslationUpdateTable updateTable;

  late final _is.ColumnString locale;

  late final _is.ColumnString key;

  late final _is.ColumnString value;

  late final _is.ColumnInt version;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    locale,
    key,
    value,
    version,
    updatedAt,
  ];
}

class AppTranslationInclude extends _is.IncludeObject {
  AppTranslationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AppTranslation.t;
}

class AppTranslationIncludeList extends _is.IncludeList {
  AppTranslationIncludeList._({
    _is.WhereExpressionBuilder<AppTranslationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppTranslation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AppTranslation.t;
}

class AppTranslationRepository {
  const AppTranslationRepository._();

  /// Returns a list of [AppTranslation]s matching the given query parameters.
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
  Future<List<AppTranslation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppTranslationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppTranslation>(
      where: where?.call(AppTranslation.t),
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppTranslation] matching the given query parameters.
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
  Future<AppTranslation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppTranslationTable>? where,
    int? offset,
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppTranslation>(
      where: where?.call(AppTranslation.t),
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppTranslation] by its [id] or null if no such row exists.
  Future<AppTranslation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppTranslation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppTranslation]s in the list and returns the inserted rows.
  ///
  /// The returned [AppTranslation]s will have their `id` fields set.
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
  Future<List<AppTranslation>> insert(
    _is.DatabaseSession session,
    List<AppTranslation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AppTranslation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AppTranslation] and returns the inserted row.
  ///
  /// The returned [AppTranslation] will have its `id` field set.
  Future<AppTranslation> insertRow(
    _is.DatabaseSession session,
    AppTranslation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppTranslation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AppTranslation]s in the list and returns the resulting rows.
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
  /// The returned [AppTranslation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppTranslation>> upsert(
    _is.DatabaseSession session,
    List<AppTranslation> rows, {
    required _is.ColumnSelections<AppTranslationTable> conflictColumns,
    _is.ColumnSelections<AppTranslationTable>? updateColumns,
    _is.WhereExpressionBuilder<AppTranslationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AppTranslation>(
      rows,
      conflictColumns: conflictColumns(AppTranslation.t),
      updateColumns: updateColumns?.call(AppTranslation.t),
      updateWhere: updateWhere?.call(AppTranslation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AppTranslation] and returns the resulting row.
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
  /// The returned [AppTranslation] will have its `id` field set.
  Future<AppTranslation?> upsertRow(
    _is.DatabaseSession session,
    AppTranslation row, {
    required _is.ColumnSelections<AppTranslationTable> conflictColumns,
    _is.ColumnSelections<AppTranslationTable>? updateColumns,
    _is.WhereExpressionBuilder<AppTranslationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AppTranslation>(
      row,
      conflictColumns: conflictColumns(AppTranslation.t),
      updateColumns: updateColumns?.call(AppTranslation.t),
      updateWhere: updateWhere?.call(AppTranslation.t),
      transaction: transaction,
    );
  }

  /// Updates all [AppTranslation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppTranslation>> update(
    _is.DatabaseSession session,
    List<AppTranslation> rows, {
    _is.ColumnSelections<AppTranslationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AppTranslation>(
      rows,
      columns: columns?.call(AppTranslation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AppTranslation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppTranslation> updateRow(
    _is.DatabaseSession session,
    AppTranslation row, {
    _is.ColumnSelections<AppTranslationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppTranslation>(
      row,
      columns: columns?.call(AppTranslation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppTranslation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppTranslation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AppTranslationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AppTranslation>(
      id,
      columnValues: columnValues(AppTranslation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppTranslation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppTranslation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AppTranslationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AppTranslationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AppTranslation>(
      columnValues: columnValues(AppTranslation.t.updateTable),
      where: where(AppTranslation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AppTranslation]s in the list and returns the deleted rows.
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
  Future<List<AppTranslation>> delete(
    _is.DatabaseSession session,
    List<AppTranslation> rows, {
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AppTranslation>(
      rows,
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AppTranslation].
  Future<AppTranslation> deleteRow(
    _is.DatabaseSession session,
    AppTranslation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppTranslation>(
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
  Future<List<AppTranslation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppTranslationTable> where,
    _is.OrderByBuilder<AppTranslationTable>? orderBy,
    _is.OrderByListBuilder<AppTranslationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AppTranslation>(
      where: where(AppTranslation.t),
      orderBy: orderBy?.call(AppTranslation.t),
      orderByList: orderByList?.call(AppTranslation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppTranslationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AppTranslation>(
      where: where?.call(AppTranslation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppTranslation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppTranslationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppTranslation>(
      where: where(AppTranslation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
