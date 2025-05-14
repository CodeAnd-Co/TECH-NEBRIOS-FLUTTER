// Archivo: test/mocks/rock.dart
import 'package:mockito/annotations.dart';
import 'package:tech_nebrios_tracker/domain/consultarCharolaUseCase.dart';
import 'package:tech_nebrios_tracker/domain/eliminarCharolaUseCase.dart';
import 'package:tech_nebrios_tracker/domain/charolasDashboardUseCase.dart';

@GenerateMocks([
  EliminarCharolaUseCase,
  ObtenerCharolaUseCase,
  ObtenerMenuCharolas,
])
void main() {}
