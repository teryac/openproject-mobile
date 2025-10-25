/// This method returns `true` if the current page
/// is that last page in pagination
bool isLastPage({
  required int total,
  required int pageSize,
  required int currentPage,
}) {
  return currentPage == (total / pageSize).ceil();
}
