abstract class LocalStorageService {
  Future<String?> getCurrentUser();
  Future<void> setCurrentUser(String usuario);
  Future<void> removeCurrentUser();
}