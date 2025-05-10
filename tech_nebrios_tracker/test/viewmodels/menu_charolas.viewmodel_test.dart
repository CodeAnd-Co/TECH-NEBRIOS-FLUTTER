import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.mocks.dart';
import 'package:tech_nebrios_tracker/data/models/menu_charolas.model.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/menu_charolas.viewmodel.dart';

void main() {
  // Declaración de mocks y ViewModel
  late MockObtenerMenuCharolas mockUseCase;
  late CharolaVistaModelo viewModel;

  /// Se ejecuta antes de cada prueba. Inicializa el mock y el ViewModel.
  setUp(() {
    mockUseCase = MockObtenerMenuCharolas();
    viewModel = CharolaVistaModelo(casoUso: mockUseCase);
  });

  /// Prueba: Verifica que una carga exitosa actualiza la lista de charolas correctamente.
  test('✅ carga exitosa actualiza la lista de charolas', () async {
    // Simula respuesta con una charola
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenAnswer((_) async => CharolaTarjeta(
              total: 1,
              pag: 1,
              limite: 12,
              totalPags: 1,
              data: [Charola(charolaId: 1,nombreCharola:  'E-001', fechaCreacion: DateTime.parse('2025-04-01'))],
            ));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.length, 1);
    expect(viewModel.charolas[0].nombreCharola, 'E-001');
    expect(viewModel.totalPags, 1);
  });

  /// Prueba: Carga con lista vacía. Verifica que el ViewModel actualiza correctamente sin datos.
  test('✅ carga con lista vacía actualiza correctamente', () async {
    // Simula respuesta vacía
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenAnswer((_) async => CharolaTarjeta(
              total: 0,
              pag: 1,
              limite: 12,
              totalPags: 0,
              data: [],
            ));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  /// Prueba: Simula un error genérico (500) y verifica que se maneja sin fallar.
  test('✅ maneja error inesperado 500', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('Error interno'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  /// Prueba: Simula error 401 no autorizado. Verifica que el ViewModel lo maneja correctamente.
  test('✅ maneja error 401 no autorizado', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('401 Unauthorized'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  /// Prueba: Simula error de red (código 101) y valida que se maneje sin fallos.
  test('✅ maneja error 101 error de red', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('101 Switching Protocols'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });
}
