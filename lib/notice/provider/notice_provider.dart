import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

final noticeProvider = StateNotifierProvider<NoticeStateNotifier, List<NoticeModel>>((ref){
  final repo = ref.watch(noticeRepositoryProvider);
  return NoticeStateNotifier(repository: repo);
});


class NoticeStateNotifier extends StateNotifier<List<NoticeModel>>{
  final NoticeRepository repository;

  NoticeStateNotifier({required this.repository}) : super([]);


  getNotice()async{
    state = await repository.getNotice();
  }


}