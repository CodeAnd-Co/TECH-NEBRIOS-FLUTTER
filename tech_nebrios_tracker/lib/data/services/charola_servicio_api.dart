abstract class CharolaApiService {
  Future<Map<String, dynamic>?> fetchCharolasPaginated(int page, int limit);
}
