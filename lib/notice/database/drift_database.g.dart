// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $SiteColorsTable extends SiteColors
    with TableInfo<$SiteColorsTable, SiteColor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiteColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _siteMeta = const VerificationMeta('site');
  @override
  late final GeneratedColumn<String> site = GeneratedColumn<String>(
      'site', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hexCodeMeta =
      const VerificationMeta('hexCode');
  @override
  late final GeneratedColumn<String> hexCode = GeneratedColumn<String>(
      'hex_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [site, hexCode];
  @override
  String get aliasedName => _alias ?? 'site_colors';
  @override
  String get actualTableName => 'site_colors';
  @override
  VerificationContext validateIntegrity(Insertable<SiteColor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('site')) {
      context.handle(
          _siteMeta, site.isAcceptableOrUnknown(data['site']!, _siteMeta));
    } else if (isInserting) {
      context.missing(_siteMeta);
    }
    if (data.containsKey('hex_code')) {
      context.handle(_hexCodeMeta,
          hexCode.isAcceptableOrUnknown(data['hex_code']!, _hexCodeMeta));
    } else if (isInserting) {
      context.missing(_hexCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SiteColor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteColor(
      site: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site'])!,
      hexCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hex_code'])!,
    );
  }

  @override
  $SiteColorsTable createAlias(String alias) {
    return $SiteColorsTable(attachedDatabase, alias);
  }
}

class SiteColor extends DataClass implements Insertable<SiteColor> {
  final String site;
  final String hexCode;
  const SiteColor({required this.site, required this.hexCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['site'] = Variable<String>(site);
    map['hex_code'] = Variable<String>(hexCode);
    return map;
  }

  SiteColorsCompanion toCompanion(bool nullToAbsent) {
    return SiteColorsCompanion(
      site: Value(site),
      hexCode: Value(hexCode),
    );
  }

  factory SiteColor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteColor(
      site: serializer.fromJson<String>(json['site']),
      hexCode: serializer.fromJson<String>(json['hexCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'site': serializer.toJson<String>(site),
      'hexCode': serializer.toJson<String>(hexCode),
    };
  }

  SiteColor copyWith({String? site, String? hexCode}) => SiteColor(
        site: site ?? this.site,
        hexCode: hexCode ?? this.hexCode,
      );
  @override
  String toString() {
    return (StringBuffer('SiteColor(')
          ..write('site: $site, ')
          ..write('hexCode: $hexCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(site, hexCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteColor &&
          other.site == this.site &&
          other.hexCode == this.hexCode);
}

class SiteColorsCompanion extends UpdateCompanion<SiteColor> {
  final Value<String> site;
  final Value<String> hexCode;
  final Value<int> rowid;
  const SiteColorsCompanion({
    this.site = const Value.absent(),
    this.hexCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiteColorsCompanion.insert({
    required String site,
    required String hexCode,
    this.rowid = const Value.absent(),
  })  : site = Value(site),
        hexCode = Value(hexCode);
  static Insertable<SiteColor> custom({
    Expression<String>? site,
    Expression<String>? hexCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (site != null) 'site': site,
      if (hexCode != null) 'hex_code': hexCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiteColorsCompanion copyWith(
      {Value<String>? site, Value<String>? hexCode, Value<int>? rowid}) {
    return SiteColorsCompanion(
      site: site ?? this.site,
      hexCode: hexCode ?? this.hexCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (hexCode.present) {
      map['hex_code'] = Variable<String>(hexCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiteColorsCompanion(')
          ..write('site: $site, ')
          ..write('hexCode: $hexCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoticesTable extends Notices with TableInfo<$NoticesTable, Notice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoticesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteMeta = const VerificationMeta('site');
  @override
  late final GeneratedColumn<String> site = GeneratedColumn<String>(
      'site', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _viewsMeta = const VerificationMeta('views');
  @override
  late final GeneratedColumn<String> views = GeneratedColumn<String>(
      'views', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
      'day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, site, type, url, views, day, content];
  @override
  String get aliasedName => _alias ?? 'notices';
  @override
  String get actualTableName => 'notices';
  @override
  VerificationContext validateIntegrity(Insertable<Notice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('site')) {
      context.handle(
          _siteMeta, site.isAcceptableOrUnknown(data['site']!, _siteMeta));
    } else if (isInserting) {
      context.missing(_siteMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('views')) {
      context.handle(
          _viewsMeta, views.isAcceptableOrUnknown(data['views']!, _viewsMeta));
    } else if (isInserting) {
      context.missing(_viewsMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Notice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      site: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      views: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}views'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}day'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $NoticesTable createAlias(String alias) {
    return $NoticesTable(attachedDatabase, alias);
  }
}

class Notice extends DataClass implements Insertable<Notice> {
  final String id;
  final String title;
  final String site;
  final String type;
  final String url;
  final String views;
  final DateTime day;
  final String content;
  const Notice(
      {required this.id,
      required this.title,
      required this.site,
      required this.type,
      required this.url,
      required this.views,
      required this.day,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['site'] = Variable<String>(site);
    map['type'] = Variable<String>(type);
    map['url'] = Variable<String>(url);
    map['views'] = Variable<String>(views);
    map['day'] = Variable<DateTime>(day);
    map['content'] = Variable<String>(content);
    return map;
  }

  NoticesCompanion toCompanion(bool nullToAbsent) {
    return NoticesCompanion(
      id: Value(id),
      title: Value(title),
      site: Value(site),
      type: Value(type),
      url: Value(url),
      views: Value(views),
      day: Value(day),
      content: Value(content),
    );
  }

  factory Notice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notice(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      site: serializer.fromJson<String>(json['site']),
      type: serializer.fromJson<String>(json['type']),
      url: serializer.fromJson<String>(json['url']),
      views: serializer.fromJson<String>(json['views']),
      day: serializer.fromJson<DateTime>(json['day']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'site': serializer.toJson<String>(site),
      'type': serializer.toJson<String>(type),
      'url': serializer.toJson<String>(url),
      'views': serializer.toJson<String>(views),
      'day': serializer.toJson<DateTime>(day),
      'content': serializer.toJson<String>(content),
    };
  }

  Notice copyWith(
          {String? id,
          String? title,
          String? site,
          String? type,
          String? url,
          String? views,
          DateTime? day,
          String? content}) =>
      Notice(
        id: id ?? this.id,
        title: title ?? this.title,
        site: site ?? this.site,
        type: type ?? this.type,
        url: url ?? this.url,
        views: views ?? this.views,
        day: day ?? this.day,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('Notice(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('site: $site, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('views: $views, ')
          ..write('day: $day, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, site, type, url, views, day, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notice &&
          other.id == this.id &&
          other.title == this.title &&
          other.site == this.site &&
          other.type == this.type &&
          other.url == this.url &&
          other.views == this.views &&
          other.day == this.day &&
          other.content == this.content);
}

class NoticesCompanion extends UpdateCompanion<Notice> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> site;
  final Value<String> type;
  final Value<String> url;
  final Value<String> views;
  final Value<DateTime> day;
  final Value<String> content;
  final Value<int> rowid;
  const NoticesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.site = const Value.absent(),
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.views = const Value.absent(),
    this.day = const Value.absent(),
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoticesCompanion.insert({
    required String id,
    required String title,
    required String site,
    required String type,
    required String url,
    required String views,
    required DateTime day,
    required String content,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        site = Value(site),
        type = Value(type),
        url = Value(url),
        views = Value(views),
        day = Value(day),
        content = Value(content);
  static Insertable<Notice> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? site,
    Expression<String>? type,
    Expression<String>? url,
    Expression<String>? views,
    Expression<DateTime>? day,
    Expression<String>? content,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (site != null) 'site': site,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (views != null) 'views': views,
      if (day != null) 'day': day,
      if (content != null) 'content': content,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoticesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? site,
      Value<String>? type,
      Value<String>? url,
      Value<String>? views,
      Value<DateTime>? day,
      Value<String>? content,
      Value<int>? rowid}) {
    return NoticesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      site: site ?? this.site,
      type: type ?? this.type,
      url: url ?? this.url,
      views: views ?? this.views,
      day: day ?? this.day,
      content: content ?? this.content,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (views.present) {
      map['views'] = Variable<String>(views.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoticesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('site: $site, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('views: $views, ')
          ..write('day: $day, ')
          ..write('content: $content, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $SiteColorsTable siteColors = $SiteColorsTable(this);
  late final $NoticesTable notices = $NoticesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [siteColors, notices];
}
