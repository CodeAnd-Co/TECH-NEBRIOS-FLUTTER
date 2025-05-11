import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tech_nebrios_tracker/framework/viewmodels/alimentacion_viewmodel.dart';
import 'package:tech_nebrios_tracker/data/models/alimentacion_model.dart';
import 'package:tech_nebrios_tracker/data/repositories/alimentacion_repository.dart';
import 'package:tech_nebrios_tracker/domain/alimentacion_domain.dart';

import '../mocks/mocks.mocks.dart';

@GenerateMocks([
  AlimentacionRepository,
  EliminarAlimentoCasoUso,
])
void main() {
  late MockAlimentacionRepository mockRepo;
  late MockEliminarAlimentoCasoUso mockEliminar;
  late AlimentacionViewModel vm;

  setUp(() {
    mockRepo = MockAlimentacionRepository();
    mockEliminar = MockEliminarAlimentoCasoUso();
    vm = AlimentacionViewModel(
      repo: mockRepo,
      eliminarCasoUso: mockEliminar, 
    );
  });

  group('cargarAlimentos', () {
    test('✅ carga exitosa actualiza lista y notifica', () async {
      final lista = [
        Alimento(
          idAlimento: 1,
          nombreAlimento: 'Manzana',
          descripcionAlimento: 'Fruta roja',
        )
      ];
      when(mockRepo.obtenerAlimentos()).thenAnswer((_) async => lista);

      final notifications = <bool>[];
      vm.addListener(() {
        notifications.add(vm.isLoading);
      });

      await vm.cargarAlimentos();

      // Datos actualizados correctamente
      expect(vm.alimentos, equals(lista));
      expect(vm.error, isNull);
      expect(vm.isLoading, isFalse);

      // Debe notificar: true (inicio), true (chunk agregado), false (fin)
      expect(
        notifications,
        equals([true, true, false]),
        reason: 'Notificaciones de isLoading: carga iniciada, chunk agregado, carga finalizada',
      );
    });

    test('❌ error en repo setea mensaje de error', () async {
      when(mockRepo.obtenerAlimentos()).thenThrow(Exception('boom'));

      await vm.cargarAlimentos();

      expect(vm.alimentos, isEmpty);
      expect(vm.error, contains('Error al cargar alimentos'));
      expect(vm.isLoading, isFalse);
    });
  });

  group('eliminarAlimento por id', () {
    const idValido = 42;
    final listaPostElim = [
      Alimento(idAlimento: 1, nombreAlimento: 'A', descripcionAlimento: 'X'),
      Alimento(idAlimento: 2, nombreAlimento: 'B', descripcionAlimento: 'Y'),
    ];

    test('✅ elimina correctamente y recarga la lista', () async {
      when(mockEliminar.eliminar(idAlimento: idValido))
          .thenAnswer((_) async {});
      when(mockRepo.obtenerAlimentos())
          .thenAnswer((_) async => listaPostElim);

      await vm.eliminarAlimento(idValido);

      expect(vm.alimentos, equals(listaPostElim));
      expect(vm.isLoading, isFalse);

      verifyInOrder([
        mockEliminar.eliminar(idAlimento: idValido),
        mockRepo.obtenerAlimentos(),
      ]);
    });

    test('❌ maneja error 500 como Error del servidor', () async {
      when(mockEliminar.eliminar(idAlimento: idValido))
          .thenThrow(Exception('500 Internal Server Error'));

      expect(
        () async => vm.eliminarAlimento(idValido),
        throwsA(predicate(
            (e) => e is Exception && e.toString().contains('❌ Error del servidor.'))),
      );
      expect(vm.isLoading, isFalse);
    });

    test('❌ maneja otros errores como Error desconocido', () async {
      when(mockEliminar.eliminar(idAlimento: idValido))
          .thenThrow(Exception('XYZ failure'));

      expect(
        () async => vm.eliminarAlimento(idValido),
        throwsA(predicate(
            (e) => e is Exception && e.toString().contains('❌ Error desconocido.'))),
      );
      expect(vm.isLoading, isFalse);
    });
  });
}