String truncateQuery(String query, int maxLength) {
  if (query.length <= maxLength) {
    return query;
  }
  return '${query.substring(0, maxLength - 3)}...';
}
