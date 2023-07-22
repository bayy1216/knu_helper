import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

final noticeRepositoryProvider = Provider((ref) => NoticeRepository());

class NoticeRepository{

  Future<List<NoticeModel>> getNotice()async{
    var document = FirebaseFirestore.instance
        .collection('notice')
        .orderBy('day',descending: true);
    var data = await document.get();
    return data.docs.map<NoticeModel>( (e) => NoticeModel.fromJson(e.data()) ).toList();
  }


  Future<List<NoticeModel>> paginate({required List<String> siteList,required int limit})async{
    //파이어베이스 페이지내이션을 커서로 하게되면 사용량에 모든 데이터를 검색했다고 인식하여 어쩔수없다
    print("[SiteList] $siteList");
    final List<NoticeModel> list = [];

    for(var site in siteList){
      print(SiteEnum.getType[site]!.englishName);
      var document = FirebaseFirestore.instance
          .collection('notice').doc('notice_category').collection(SiteEnum.getType[site]!.englishName)
          .orderBy('day',descending: true).orderBy('views',descending: false).limit(limit);
      var data = await document.get();
      list.addAll(data.docs.map<NoticeModel>( (e) => NoticeModel.fromJson(e.data()) ).toList());
    }
    list.sort((a, b) {
      if(a.day.compareTo(b.day) > 0){
        return -1;
      }else if (a.day.compareTo(b.day) == 0){
        if(a.views < b.views){
          return -1;
        }
        else{
          return 1;
        }
      }else{
        return 1;
      }
    });


    return list;
  }

  Future<List<NoticeModel>> searchNotice({required List<String> siteList})async{
    print("[SiteList] $siteList");
    final List<NoticeModel> list = [];

    for(var site in siteList){
      print(SiteEnum.getType[site]!.englishName);
      var document = FirebaseFirestore.instance
          .collection('notice').doc('notice_category').collection(SiteEnum.getType[site]!.englishName);
      var data = await document.get();
      list.addAll(data.docs.map<NoticeModel>( (e) => NoticeModel.fromJson(e.data()) ).toList());
    }
    list.sort((a, b) {
      if(a.day.compareTo(b.day) > 0){
        return -1;
      }else if (a.day.compareTo(b.day) == 0){
        if(a.views < b.views){
          return -1;
        }
        else{
          return 1;
        }
      }else{
        return 1;
      }
    });


    return list;
  }


}