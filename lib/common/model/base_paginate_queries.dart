class BasePaginationQueries{
  int page;
  int size;

  BasePaginationQueries({
    required this.page,
    required this.size,
  });

  updateQuires({
    int? page,
    int? size,
  }){
    this.page = page ?? this.page;
    this.size = size ?? this.size;
  }
}