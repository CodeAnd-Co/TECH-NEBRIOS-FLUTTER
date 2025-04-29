import 'package:tech_nebrios_tracker/data/repositories/user_repository.dart';

class UserUseCases {
  final UserRepository _repository;
  
  UserUseCases({UserRepository? repository}) 
      : _repository = repository ?? UserRepository();
  
  Future<String?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }
  
  Future<void> setCurrentUser(String usuario) async {
    await _repository.setCurrentUser(usuario);
  }
  
  Future<void> removeCurrentUser() async {
    await _repository.removeCurrentUser();
  }
}