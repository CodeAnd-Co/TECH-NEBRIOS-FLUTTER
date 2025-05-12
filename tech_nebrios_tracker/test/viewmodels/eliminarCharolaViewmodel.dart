import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/charola_viewmodel.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late MockObtenerCharolaUseCase mockObtenerUseCase;
  late MockEliminarCharolaUseCase mockEliminarUseCase;
  late CharolaViewModel viewModel;

  setUp(() {
    mockObtenerUseCase = MockObtenerCharolaUseCase();
    mockEliminarUseCase = MockEliminarCharolaUseCase();
    viewModel = CharolaViewModel(mockObtenerUseCase, mockEliminarUseCase);
  });

  test('eliminación exitosa de charola limpia el estado', () async {
    // Arrange
    when(mockEliminarUseCase.eliminar(1011))
        .thenAnswer((_) async => null);

    // Estado simulado antes de eliminar
    await viewModel.cargarCharola(1011);

    // Act
    await viewModel.eliminarCharola(1011);

    // Assert
    verify(mockEliminarUseCase.eliminar(1011)).called(1);
    expect(viewModel.charola, isNull);
    expect(viewModel.cargando, false);
  });

  test('error al eliminar charola no lanza excepción', () async {
    // Arrange
    when(mockEliminarUseCase.eliminar(1011))
        .thenThrow(Exception('Falló la eliminación'));

    // Act
    await viewModel.eliminarCharola(1011);

    // Assert
    verify(mockEliminarUseCase.eliminar(1011)).called(1);
    expect(viewModel.charola, isNull); // Si decides mantener null aun con error
    expect(viewModel.cargando, false);
  });
}
