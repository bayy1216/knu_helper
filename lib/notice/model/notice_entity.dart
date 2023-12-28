
import 'package:drift/drift.dart';

@DataClassName('NoticeEntity')
class NoticeEntities extends Table{
  IntColumn get id => integer()();
  TextColumn get title =>text()();
  TextColumn get site =>text()();
  TextColumn get type =>text()();
  TextColumn get url =>text()();
  IntColumn get views=>integer()();
  DateTimeColumn get day =>dateTime()();


  @override
  Set<Column> get primaryKey => {id}; // id를 기본 키로 지정
}