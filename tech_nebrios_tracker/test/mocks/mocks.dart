// Archivo: test/mocks/rock.dart
import 'package:mockito/annotations.dart';
import 'package:tech_nebrios_tracker/domain/consular_charola.dart';
import 'package:tech_nebrios_tracker/domain/eliminar_charola.dart';
import 'package:tech_nebrios_tracker/domain/getMenuCharolas.dart';

@GenerateMocks([
  EliminarCharolaUseCase,
  ObtenerCharolaUseCase,
  ObtenerMenuCharolas,
])
void main() {}
