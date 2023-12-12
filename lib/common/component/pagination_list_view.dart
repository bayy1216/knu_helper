
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/color.dart';
import '../model/offset_pagination_model.dart';
import '../provider/paginating_provider.dart';
import '../repository/base_pagination_repository.dart';
import '../utils/paination_utils.dart';

typedef PaginationWidgetBuilder<T>
= Widget Function(BuildContext context, int index,T model);


class PaginationListView<T> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider<T,IBasePaginationRepository>, OffsetPaginationBase>
  provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    Key? key,
    required this.provider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView<T>> createState() => PaginationListViewState<T>();
}


class PaginationListViewState<T> extends ConsumerState<PaginationListView<T>> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  Future<void> forceRefetch()async{
    if(ref.read(widget.provider) is !OffsetPaginationLoading){
      await ref.read(widget.provider.notifier).paginate(
        forceRefetch: true,
      );
    }
  }



  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      paginationProvider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);


    if (state is OffsetPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is OffsetPaginationError) {
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
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: const Text('다시시도'),
          ),
        ],
      );
    }
    final cp = state as OffsetPagination<T>;


    return RefreshIndicator(
      onRefresh: () async {
        await forceRefetch();
      },
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if(index == cp.data.length){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
              child: Center(
                child: cp is OffsetPaginationRefetchingMore ?
                const CircularProgressIndicator() : const SizedBox(),
              ),
            );
          }

          final pItem = cp.data[index];

          return widget.itemBuilder(context, index, pItem);

        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: DIVIDIER_GREY,
            thickness: 0.5,
          );
        },
      ),
    );
  }
}