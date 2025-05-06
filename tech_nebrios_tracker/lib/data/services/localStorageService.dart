abstract class LocalStorageService {
  Future<String?> getCurrentUser();
  Future<void> setCurrentUser(String token);
  Future<void> removeCurrentUser();
}