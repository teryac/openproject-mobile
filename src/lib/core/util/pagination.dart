bool isLastPage({
  required int total,
  required int pageSize,
  required int currentPage,
}) {
  return currentPage == (total / pageSize).ceil();
}
