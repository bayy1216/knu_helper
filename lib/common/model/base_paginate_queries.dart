class BasePaginationQuires{
  int page;
  int size;

  BasePaginationQuires({
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