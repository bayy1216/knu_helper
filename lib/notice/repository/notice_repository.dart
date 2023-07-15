import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/notice_model.dart';

final noticeRepositoryProvider = Provider((ref) => NoticeRepository());

class NoticeRepository{

  Future<List<NoticeModel>> getNotice()async{
    var document = FirebaseFirestore.instance
        .collection('notice')
        .orderBy('day',descending: true);
    var data = await document.get();
    return data.docs.map<NoticeModel>( (e) => NoticeModel.fromJson(e.data()) ).toList();
  }


  Future<List<NoticeModel>> paginate({required DateTime afterDay, required int periodDay})async{
    print("[Paginate] $afterDay -> $periodDay");
    final start = DataUtils.dateTimeToString(afterDay);
    final end = DataUtils.dateTimeToString(afterDay.subtract(Duration(days: periodDay)));
    var document = FirebaseFirestore.instance
        .collection('notice')
        .orderBy('day',descending: true).startAt([start]).endAt([end]);
    var data = await document.get();

    return data.docs.map<NoticeModel>( (e) => NoticeModel.fromJson(e.data()) ).toList();


  }

}