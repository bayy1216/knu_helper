import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/model/offset_pagination_model.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../components/notice_card.dart';
import '../components/star_icon_button.dart';
import '../model/response/notice_model.dart';
import '../provider/notice_provider.dart';

class NoticeWebView extends ConsumerWidget {
  final String url;

  static String get routeName => 'notice_web_view';

  static String get favoriteRouteName => 'favorite_notice_web_view';

  const NoticeWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notice = (ref.watch(noticeProvider) as OffsetPagination<NoticeModel>)
        .data
        .firstWhere((e) => e.url == url);

    final favorite = ref.watch(favoriteStreamProvider);
    final bool favoriteState = favorite.when(
      data: (data) => data.map((e) => e.id).toList().contains(notice.id),
      error: (error, stackTrace) => false,
      loading: () => false,
    );
    return DefaultLayout(
      title: notice.title,
      actions: [
        StarIconButton(
          isFavorite: favoriteState,
          onStarClick: (value) {
            ref
                .read(favoriteStreamProvider.notifier)
                .starClick(model: notice, isDelete: value);
          },
        ),
        IconButton(
          icon: const Icon(Icons.public),
          tooltip: '브라우저에서 열기',
          onPressed: () {
            launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}
