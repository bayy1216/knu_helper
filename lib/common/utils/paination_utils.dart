import 'package:flutter/material.dart';

import '../provider/paginating_provider.dart';
import '../repository/base_pagination_repository.dart';

class PaginationUtils {
  static void paginate<T>({
    required ScrollController controller,
    required PaginationProvider<T,IBasePaginationRepository> paginationProvider,
  }) async{
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      await paginationProvider.paginate(
        fetchMore: true,
      );
    }
  }
}