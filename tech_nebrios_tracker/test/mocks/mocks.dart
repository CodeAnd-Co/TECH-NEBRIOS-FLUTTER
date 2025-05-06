import 'package:mockito/annotations.dart';
import 'package:tech_nebrios_tracker/domain/alimentacion_domain.dart';
import 'package:tech_nebrios_tracker/data/repositories/alimento_repository.dart';

@GenerateMocks([
  EditarAlimentoCasoUso, 
  AlimentoRepository     
])
void main() {}