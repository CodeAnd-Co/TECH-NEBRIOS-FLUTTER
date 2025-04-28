import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_nebrios_tracker/data/models/menu_charolas.model.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/menu_charolas.viewmodel.dart';

import '../mocks/mocks.mocks.dart'; // Aquí es tu ruta al mock generado

void main() {
  late MockObtenerMenuCharolas mockUseCase;
  late CharolaVistaModelo viewModel;

  setUp(() {
    mockUseCase = MockObtenerMenuCharolas();
    viewModel = CharolaVistaModelo(casoUso: mockUseCase);
  });

  test('✅ carga exitosa actualiza la lista de charolas', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite'))).thenAnswer((_) async =>
      CharolaTarjeta(
        total: 1,
        pag: 1,
        limite: 12,
        totalPags: 1,
        data: [
          Charola(nombreCharola: 'E-001', fechaCreacion: DateTime.parse('2025-04-01'))
        ],
      )
    );

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.length, 1);
    expect(viewModel.charolas[0].nombreCharola, 'E-001');
    expect(viewModel.totalPags, 1);
  });

  test('✅ carga con lista vacía actualiza correctamente', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite'))).thenAnswer((_) async =>
      CharolaTarjeta(
        total: 0,
        pag: 1,
        limite: 12,
        totalPags: 0,
        data: [],
      )
    );
    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  test('✅ maneja error inesperado 500', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('Error interno'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  test('✅ maneja error 401 no autorizado', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('401 Unauthorized'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });

  test('✅ maneja error 101 error de red', () async {
    when(mockUseCase.ejecutar(pag: anyNamed('pag'), limite: anyNamed('limite')))
        .thenThrow(Exception('101 Switching Protocols'));

    await viewModel.cargarCharolas();

    expect(viewModel.charolas.isEmpty, true);
  });
}