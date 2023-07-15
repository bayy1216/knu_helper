import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/notice_web_view.dart';


class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  final ScrollController controller = ScrollController();

  int periodDay = 7;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() async {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      int result = await ref
          .read(noticeProvider.notifier)
          .paginate(fetchMore: true, periodDay: periodDay);
      if (result == 0) {
        periodDay += 14;
        if (periodDay >= 70) {
          print('마지막입니다');
          ref.read(noticeProvider.notifier).updateToEnd();
        }
      } else if (result > 0) {
        periodDay = 7;
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noticeProvider);
    print("[noti]REBUILD");
    if (state is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시시도'),
          ),
        ],
      );
    }
    final cp = state as CursorPagination<NoticeModel>;

    return SafeArea(
      child: DefaultLayout(
        title: '검색하기',
        actions: [
          IconButton(
            onPressed: () {
              print('gd');
              ref
                  .read(noticeProvider.notifier)
                  .paginate(fetchMore: true, periodDay: 5);
            },
            icon: const Icon(Icons.search),
          )
        ],
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (context, index) {
            if (index == cp.data.length) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: cp is CursorPaginationRefetchingMore
                      ? CircularProgressIndicator()
                      : Text('마지막 데이터 입니다.'),
                ),
              );
            }


            return NoticeCard.fromModel(
              model: cp.data[index],
              onStarClick: () {
                ref.read(databaseProvider).insertNotice(cp.data[index]);
                ref.read(noticeProvider.notifier).toggleStar(model: cp.data[index], value: true);
              },
              offStarClick: () {
                ref.read(databaseProvider).deleteNotice(cp.data[index]);
                ref.read(noticeProvider.notifier).toggleStar(model: cp.data[index], value: false);
              },
              isFavorite: cp.isFavorite![index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8.0);
          },
        ),
      ),
    );
  }
}
